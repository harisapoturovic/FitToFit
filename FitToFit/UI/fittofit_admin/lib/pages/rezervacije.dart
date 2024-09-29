import 'package:fittofit_admin/models/clanarine.dart';
import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/rezervacije.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/pages/arhiva.dart';
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

class RezervacijePage extends StatefulWidget {
  const RezervacijePage({Key? key}) : super(key: key);

  @override
  State<RezervacijePage> createState() => _RezervacijePageState();
}

class _RezervacijePageState extends State<RezervacijePage> {
  late RezervacijeProvider _rezervacijeProvider;
  late KorisniciProvider _korisniciProvider;
  late TreninziProvider _treninziProvider;
  late ClanarineProvider _clanarineProvider;
  List<Rezervacije> _aktivneRezervacijeList = [];
  List<Rezervacije> _draftRezervacijeList = [];
  List<Rezervacije> _selectedRezervacije = [];
  List<Korisnici> _korisniciList = [];
  List<Treninzi> _treninziList = [];
  List<Clanarine> _clanarineList = [];
  DateTime? _selectedDate;
  int? _selectedKorisnik;
  int? _selectedTrening;
  int? _selectedClanarina;
  bool isActive = true;
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
    _rezervacijeProvider.addListener(() {
      _reloadRezervacijeList();
      setTotalItems();
    });
  }

  void setTotalItems() async {
    var rezervacijeResult = await _rezervacijeProvider
        .get(filter: {'page': page, 'pageSize': pageSize});

    if (mounted) {
      setState(() {
        totalcount = rezervacijeResult.count;
      });

      int totalPages = (totalcount / pageSize).ceil();

      if (page >= totalPages && totalPages > 0) {
        setState(() {
          page--;
        });
      }
      _reloadRezervacijeList();
    }
  }

  void _reloadRezervacijeList() async {
    var aktivneRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "active",
      'page': page,
      'pageSize': pageSize
    });

    var draftRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "draft",
      'page': page,
      'pageSize': pageSize
    });
    if (mounted) {
      setState(() {
        _aktivneRezervacijeList = aktivneRezervacije.result;
        _draftRezervacijeList = draftRezervacije.result;
        _selectedRezervacije =
            isActive ? _aktivneRezervacijeList : _draftRezervacijeList;
        totalcount =
            isActive ? aktivneRezervacije.count : draftRezervacije.count;
      });
    }
  }

  void _loadData() async {
    if (!mounted) return;
    isSearching = false;
    var aktivneRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "active",
      'page': page,
      'pageSize': pageSize
    });

    var draftRezervacije = await _rezervacijeProvider.get(filter: {
      'IsTerminiIncluded': true,
      'StateMachine': "draft",
      'page': page,
      'pageSize': pageSize
    });
    var korisnici = await _korisniciProvider.get(filter: {'isKorisnik': true});
    var treninzi = await _treninziProvider.get(filter: {});
    var clanarine = await _clanarineProvider.get(filter: {});

    if (mounted) {
      setState(() {
        _aktivneRezervacijeList = aktivneRezervacije.result;
        _draftRezervacijeList = draftRezervacije.result;
        _korisniciList = korisnici.result;
        _treninziList = treninzi.result;
        _clanarineList = clanarine.result;

        _selectedRezervacije =
            isActive ? _aktivneRezervacijeList : _draftRezervacijeList;
        totalcount =
            isActive ? aktivneRezervacije.count : draftRezervacije.count;
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
      title: "Rezervacije",
      selectedIndex: 4,
      showBackArrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          Container(child: _searchWidgets()),
          const SizedBox(height: 10),
          Expanded(child: _buildDataListView()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 630),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArhivaPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 159, 160, 255),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  const Text('ARHIVA', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 50),
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
                      isActive = true;
                      _selectedRezervacije = _aktivneRezervacijeList;
                    });
                    getFilteredReservations();
                  },
                  child: Text(
                    'Aktivne rezervacije',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: isActive
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
                      isActive = false;
                      _selectedRezervacije = _draftRezervacijeList;
                    });
                    getFilteredReservations();
                  },
                  child: Text(
                    'Draft rezervacije',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.grey : Colors.blue),
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
                                  isActive
                                      ? Container()
                                      : Tooltip(
                                          message: "Aktiviraj",
                                          textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          child: IconButton(
                                            icon: const Icon(Icons.done),
                                            onPressed: () {
                                              _confirmActivateReservation(
                                                  context, e.rezervacijaId);
                                            },
                                          ),
                                        ),
                                  isActive
                                      ? Tooltip(
                                          message: "Arhiviraj",
                                          textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          child: IconButton(
                                            icon: const Icon(Icons.access_time),
                                            onPressed: () {
                                              _confirmArchiveReservation(
                                                  context, e.rezervacijaId);
                                            },
                                          ),
                                        )
                                      : Tooltip(
                                          message: "Izbriši",
                                          textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          child: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              _confirmDeleteReservation(
                                                  context, e.rezervacijaId);
                                            },
                                          ),
                                        ),
                                  isActive
                                      ? Tooltip(
                                          message: 'Poništi',
                                          textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              _confirmCancelReservation(
                                                  context, e.rezervacijaId);
                                            },
                                          ),
                                        )
                                      : Tooltip(
                                          message: 'Odbij',
                                          textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          child: IconButton(
                                            icon: const Icon(Icons.block),
                                            onPressed: () {
                                              _confirmRefuseReservation(
                                                  context, e.rezervacijaId);
                                            },
                                          ),
                                        )
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
                            setState(() {
                              _selectedKorisnik = null;
                              _loadData();
                            });
                          },
                        )
                      : null,
                ),
                value: _selectedKorisnik,
                items: _korisniciList.map((Korisnici korisnik) {
                  return DropdownMenuItem<int?>(
                    value: korisnik.korisnikId,
                    child: Text('${korisnik.ime} ${korisnik.prezime}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKorisnik = value;
                    _loadData();
                  });
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
                              setState(() {
                                _selectedDate = null;
                                _loadData();
                              });
                            },
                          )
                        : null,
                  ),
                  format: DateFormat("d.M.yyyy."),
                  initialValue: _selectedDate,
                  onChanged: (value) {
                    setState(() {
                      _selectedDate = value;
                      _loadData();
                    });
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
                            setState(() {
                              _selectedTrening = null;
                              _loadData();
                            });
                          },
                        )
                      : null,
                ),
                value: _selectedTrening,
                items: _treninziList.map((Treninzi trening) {
                  return DropdownMenuItem<int?>(
                    value: trening.treningId,
                    child: Text(trening.naziv),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTrening = value;
                    _loadData();
                  });
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
                            setState(() {
                              _selectedClanarina = null;
                              _loadData();
                            });
                          },
                        )
                      : null,
                ),
                value: _selectedClanarina,
                items: _clanarineList.map((Clanarine clanarina) {
                  return DropdownMenuItem<int?>(
                    value: clanarina.clanarinaId,
                    child: Text(clanarina.naziv),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClanarina = value;
                    _loadData();
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 80),
                child: ElevatedButton(
                  onPressed: () async {
                    await getFilteredReservations();
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
      'stateMachine': "active",
      'page': page,
      'pageSize': pageSize
    });

    var data2 = await _rezervacijeProvider.get(filter: {
      'datum': _selectedDate,
      'korisnikId': _selectedKorisnik,
      'clanarinaId': _selectedClanarina,
      'treningId': _selectedTrening,
      'stateMachine': "draft",
      'page': page,
      'pageSize': pageSize
    });

    setState(() {
      _aktivneRezervacijeList = data1.result;
      _draftRezervacijeList = data2.result;
      if (isActive) {
        _selectedRezervacije = _aktivneRezervacijeList;
        totalcount = data1.count;
      } else {
        _selectedRezervacije = _draftRezervacijeList;
        totalcount = data2.count;
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

  void _confirmArchiveReservation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda arhiviranja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content:
              const Text('Da li ste sigurni da želite arhivirati rezervaciju?'),
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
                _arhivirajRezervaciju(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Arhiviraj',
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

  void _confirmActivateReservation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda aktiviranja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content:
              const Text('Da li ste sigurni da želite aktivirati rezervaciju?'),
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
                _aktivirajRezervaciju(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Aktiviraj',
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

  void _confirmRefuseReservation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda odbijanja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content:
              const Text('Da li ste sigurni da želite odbiti rezervaciju?'),
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
                _odbijRezervaciju(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Odbij',
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

  void _confirmCancelReservation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda poništavanja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content:
              const Text('Da li ste sigurni da želite poništiti rezervaciju?'),
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
                _ponistiRezervaciju(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Poništi',
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

  void _arhivirajRezervaciju(int id) async {
    try {
      await _rezervacijeProvider.archive(id);
      _showAlertDialog("Uspješno arhiviranje",
          "Rezervacija uspješno arhvirana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _aktivirajRezervaciju(int id) async {
    try {
      await _rezervacijeProvider.activate(id);
      _showAlertDialog(
          "Uspješno aktiviranje", "Akcija uspješno aktivirana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _odbijRezervaciju(int id) async {
    try {
      await _rezervacijeProvider.refuse(id);
      _showAlertDialog(
          "Uspješno odbijanje", "Akcija uspješno odbijena.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _ponistiRezervaciju(int id) async {
    try {
      await _rezervacijeProvider.cancel(id);
      _showAlertDialog(
          "Uspješno poništavanje", "Akcija uspješno poništena.", Colors.green);
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
            width: 400.0,
            height: 300.0,
            margin: const EdgeInsets.only(top: 30),
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
                    height: 20,
                  ),
                  rezervacija.brojTransakcije != null
                      ? const Text(
                          'Rezervacija plaćena online!',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        )
                      : const Text(''),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        );
      },
    );
  }
}
