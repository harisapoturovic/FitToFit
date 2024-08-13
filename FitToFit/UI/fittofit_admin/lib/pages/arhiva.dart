import 'package:fittofit_admin/models/clanarine.dart';
import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/rezervacije.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/providers/clanarine_provider.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/rezervacije_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ArhivaPage extends StatefulWidget {
  const ArhivaPage({Key? key}) : super(key: key);

  @override
  State<ArhivaPage> createState() => _ArhivaPageState();
}

class _ArhivaPageState extends State<ArhivaPage> {
  late RezervacijeProvider _rezervacijeProvider;
  late KorisniciProvider _korisniciProvider;
  late TreninziProvider _treninziProvider;
  late ClanarineProvider _clanarineProvider;
  List<Rezervacije> _arhiviraneRezervacijeList = [];
  List<Rezervacije> _odbijeneRezervacijeList = [];
  List<Rezervacije> _ponisteneRezervacijeList = [];
  List<Rezervacije> _selectedRezervacije = [];
  List<Korisnici> _korisniciList = [];
  List<Treninzi> _treninziList = [];
  List<Clanarine> _clanarineList = [];
  DateTime? _selectedDate;
  int? _selectedKorisnik;
  int? _selectedTrening;
  int? _selectedClanarina;
  bool isArchived = true;
  bool isRefused = false;
  bool isSearching = false;

  var page = 1;
  var totalcount = 0;
  var pageSize = 5;

  @override
  void initState() {
    super.initState();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _clanarineProvider = context.read<ClanarineProvider>();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    isSearching = false;
    var arhiviraneRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "archived",
      'page': page,
      'pageSize': pageSize
    });

    var odbijeneRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "refused",
      'page': page,
      'pageSize': pageSize
    });

    var ponisteneRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "canceled",
      'page': page,
      'pageSize': pageSize
    });
    var korisnici = await _korisniciProvider.get(filter: {'isAdmin': false});
    var treninzi = await _treninziProvider.get(filter: {});
    var clanarine = await _clanarineProvider.get(filter: {});
    if (mounted) {
      setState(() {
        _odbijeneRezervacijeList = odbijeneRezervacije.result;
        _arhiviraneRezervacijeList = arhiviraneRezervacije.result;
        _ponisteneRezervacijeList = ponisteneRezervacije.result;
        _korisniciList = korisnici.result;
        _treninziList = treninzi.result;
        _clanarineList = clanarine.result;

        _selectedRezervacije = isArchived
            ? _arhiviraneRezervacijeList
            : isRefused
                ? _odbijeneRezervacijeList
                : _ponisteneRezervacijeList;
        totalcount = isArchived
            ? arhiviraneRezervacije.count
            : isRefused
                ? odbijeneRezervacije.count
                : ponisteneRezervacije.count;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Arhiva",
      selectedIndex: 4,
      showBackArrow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          Container(child: _searchWidgets()),
          const SizedBox(height: 10),
          Expanded(child: _buildDataListView()),
          const SizedBox(height: 10),
          _buildPageNumbers()
        ],
      ),
    );
  }

  Widget _buildPageNumbers() {
    int totalPages = (totalcount / pageSize).ceil();
    List<Widget> pageButtons = [];

    for (int i = 1; i <= totalPages; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                page = i;
                isSearching ? getFilteredReservations() : _loadData();
              });
            },
            child: Text('$i'),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageButtons,
    );
  }

  Widget _buildDataListView() {
    return Container(
      height: 700,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isArchived = true;
                      isRefused = false;
                      _selectedRezervacije = _arhiviraneRezervacijeList;
                    });
                    getFilteredReservations();
                  },
                  child: Text(
                    'Arhivirane rezervacije',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: isArchived
                            ? const Color.fromARGB(255, 46, 142, 50)
                            : Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('/'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isArchived = false;
                      isRefused = true;
                      _selectedRezervacije = _odbijeneRezervacijeList;
                    });
                    getFilteredReservations();
                  },
                  child: Text(
                    'Odbijene rezervacije',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: isRefused ? Colors.blue : Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('/'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isArchived = false;
                      isRefused = false;
                      _selectedRezervacije = _ponisteneRezervacijeList;
                    });
                    getFilteredReservations();
                  },
                  child: Text(
                    'Poništene rezervacije',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: !isArchived && !isRefused
                            ? Colors.red
                            : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: ListView.builder(
                  itemCount: _selectedRezervacije.length,
                  itemBuilder: (context, index) {
                    final e = _selectedRezervacije[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDialog(e);
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 300.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 20),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              title: Row(
                                children: [
                                  FutureBuilder<dynamic>(
                                    future: _korisniciProvider
                                        .getById(e.korisnikId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final korisnik = snapshot.data;
                                          if (korisnik != null) {
                                            return Text(
                                              korisnik.ime +
                                                  ' ' +
                                                  korisnik.prezime,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: Color.fromRGBO(
                                                    0, 154, 231, 1),
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                                'Invalid data format');
                                          }
                                        }
                                      }
                                    },
                                  ),
                                  const Text('   |   '),
                                  Text(
                                    formatDate(e.datum),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                    ),
                                  ),
                                  const Text('   |   '),
                                  FutureBuilder<dynamic>(
                                    future: _clanarineProvider
                                        .getById(e.clanarinaId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final clanarina = snapshot.data;
                                          if (clanarina != null) {
                                            return Text(
                                              clanarina.naziv,
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Color.fromRGBO(
                                                    0, 154, 231, 1),
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                                'Invalid data format');
                                          }
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Tooltip(
                                    message: "Izbriši",
                                    textStyle: const TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _confirmDeleteReservation(
                                            context, e.rezervacijaId);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0)
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchWidgets() {
    return Container(
      color: const Color.fromARGB(255, 78, 101, 214).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DropdownButtonFormField<int?>(
                decoration: InputDecoration(
                  labelText: "Korisnici",
                  suffixIcon: _selectedKorisnik != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _selectedKorisnik = null;
                              });
                            }
                          },
                        )
                      : null,
                ),
                value: _selectedKorisnik,
                items: _korisniciList.map((Korisnici korisnik) {
                  return DropdownMenuItem(
                    value: korisnik.korisnikId,
                    child: Text('${korisnik.ime} ${korisnik.prezime}'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _selectedKorisnik = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: FormBuilderDateTimePicker(
                  name: 'datum',
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: 'Datum',
                    suffixIcon: _selectedDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.red),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _selectedDate = null;
                                });
                              }
                            },
                          )
                        : null,
                  ),
                  format: DateFormat("yyyy-MM-dd"),
                  initialValue: _selectedDate,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        _selectedDate = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<int?>(
                decoration: InputDecoration(
                  labelText: "Treninzi",
                  suffixIcon: _selectedTrening != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _selectedTrening = null;
                              });
                            }
                          },
                        )
                      : null,
                ),
                value: _selectedTrening,
                items: _treninziList.map((Treninzi trening) {
                  return DropdownMenuItem(
                    value: trening.treningId,
                    child: Text(trening.naziv),
                  );
                }).toList(),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _selectedTrening = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: DropdownButtonFormField<int?>(
                decoration: InputDecoration(
                  labelText: "Članarine",
                  suffixIcon: _selectedClanarina != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _selectedClanarina = null;
                              });
                            }
                          },
                        )
                      : null,
                ),
                value: _selectedClanarina,
                items: _clanarineList.map((Clanarine clanarina) {
                  return DropdownMenuItem(
                    value: clanarina.clanarinaId,
                    child: Text(clanarina.naziv),
                  );
                }).toList(),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _selectedClanarina = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 80),
                child: ElevatedButton(
                  onPressed: () async {
                    if (mounted) {
                      await getFilteredReservations();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 17),
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text("Pretraži"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getFilteredReservations() async {
    isSearching = true;
    var data1 = await _rezervacijeProvider.get(filter: {
      'datum': _selectedDate,
      'korisnikId': _selectedKorisnik,
      'clanarinaId': _selectedClanarina,
      'treningId': _selectedTrening,
      'stateMachine': "archived",
      'page': page,
      'pageSize': pageSize
    });

    var data2 = await _rezervacijeProvider.get(filter: {
      'datum': _selectedDate,
      'korisnikId': _selectedKorisnik,
      'clanarinaId': _selectedClanarina,
      'treningId': _selectedTrening,
      'stateMachine': "refused",
      'page': page,
      'pageSize': pageSize
    });

    var data3 = await _rezervacijeProvider.get(filter: {
      'datum': _selectedDate,
      'korisnikId': _selectedKorisnik,
      'clanarinaId': _selectedClanarina,
      'treningId': _selectedTrening,
      'stateMachine': "canceled",
      'page': page,
      'pageSize': pageSize
    });

    setState(() {
      _arhiviraneRezervacijeList = data1.result;
      _odbijeneRezervacijeList = data2.result;
      _ponisteneRezervacijeList = data3.result;

      if (isArchived) {
        _selectedRezervacije = _arhiviraneRezervacijeList;
        totalcount = data1.count;
      } else if (isRefused) {
        _selectedRezervacije = _odbijeneRezervacijeList;
        totalcount = data2.count;
      } else {
        _selectedRezervacije = _ponisteneRezervacijeList;
        totalcount = data3.count;
      }
    });
  }

  void _confirmDeleteReservation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda brisanja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
              'Da li ste sigurni da želite izbrisati ovu rezervaciju?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Odustani',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _obrisiRezervaciju(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Izbriši',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  void _obrisiRezervaciju(int rezervacijaId) async {
    try {
      await _rezervacijeProvider.delete(rezervacijaId);
      _showAlertDialog(
          "Uspješno brisanje", "Rezervacija uspješno izbrisana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _showAlertDialog(String naslov, String poruka, Color boja) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 238, 247, 255),
        title: Text(
          naslov,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: boja,
          ),
        ),
        content: Text(
          poruka,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            child: const Text("OK"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<Treninzi?> getTrainingByTrainingId(id) async {
    return await _treninziProvider.getById(id);
  }

  void _showDialog(Rezervacije rezervacija) async {
    _loadData();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalji o rezervaciji'),
          content: Container(
            width: 300.0,
            height: 300.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 30),
            child: SingleChildScrollView(
                child: Card(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: rezervacija.rezervacijaStavkes!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final stavka = rezervacija.rezervacijaStavkes![index];
                        return FutureBuilder<Treninzi?>(
                          future:
                              getTrainingByTrainingId(stavka.termin!.treningId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final training = snapshot.data;
                              final trainingName =
                                  training?.naziv ?? 'Unknown Training';
                              return ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '- ${stavka.termin!.dan} | ${stavka.termin!.sat} | $trainingName',
                                      style: const TextStyle(),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${rezervacija.iznos} KM',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }
}
