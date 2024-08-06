import 'package:fittofit_admin/models/clanarine.dart';
import 'package:fittofit_admin/models/sale.dart';
import 'package:fittofit_admin/models/termini.dart';
import 'package:fittofit_admin/models/treneri.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/models/treninziClanarine.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/clanarine_provider.dart';
import 'package:fittofit_admin/providers/sale_provider.dart';
import 'package:fittofit_admin/providers/termini_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:fittofit_admin/providers/treninzi_clanarine_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class PonudaPage extends StatefulWidget {
  const PonudaPage({Key? key}) : super(key: key);

  @override
  State<PonudaPage> createState() => _PonudaPageState();
}

class _PonudaPageState extends State<PonudaPage> {
  late TerminiProvider _terminiProvider;
  late TreninziClanarineProvider _treninziClanarineProvider;
  late TreneriProvider _treneriProvider;
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreninziProvider _treninziProvider;
  late ClanarineProvider _clanarineProvider;
  late SaleProvider _saleProvider;
  List<Termini> _terminiList = [];
  List<TreninziClanarine> _treninziClanarineList = [];
  List<Treneri> _treneriList = [];
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  List<Clanarine> _clanarineList = [];
  List<Sale> _saleList = [];
  List<dynamic> _selectedList = [];
  int? _selectedTrener;
  int? _selectedTrening;
  int? _selectedClanarina;
  int? _selectedVrstaTr;
  int? _selectedSala;
  String? _selectedDan;
  String? _selectedUcestalost;
  bool isRaspored = true;
  bool isSearching = false;
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();
  final TextEditingController _cijenaController = TextEditingController();

  var page = 1;
  var totalcount = 0;
  var pageSize = 5;

  final List<String> radniDani = [
    'Ponedjeljak',
    'Utorak',
    'Srijeda',
    'Četvrtak',
    'Petak'
  ];

  final List<String> ucestalost = ['1x', '2x', '3x', '4x', '5x'];

  @override
  void initState() {
    super.initState();
    _terminiProvider = context.read<TerminiProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _clanarineProvider = context.read<ClanarineProvider>();
    _saleProvider = context.read<SaleProvider>();
    _treninziClanarineProvider = context.read<TreninziClanarineProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    isSearching = false;
    var termini = await _terminiProvider
        .get(filter: {'page': page, 'pageSize': pageSize});
    var treninziClanarine = await _treninziClanarineProvider
        .get(filter: {'page': page, 'pageSize': pageSize});
    var treneri = await _treneriProvider.get(filter: {});
    var treninzi = await _treninziProvider.get(filter: {});
    var clanarine = await _clanarineProvider.get(filter: {});
    var sale = await _saleProvider.get(filter: {});
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});

    setState(() {
      _terminiList = termini.result;
      _treninziClanarineList = treninziClanarine.result;
      _treneriList = treneri.result;
      _treninziList = treninzi.result;
      _clanarineList = clanarine.result;
      _saleList = sale.result;
      _vrsteTreningaList = vrsteTreninga.result;

      _selectedList = isRaspored ? _terminiList : _treninziClanarineList;
      totalcount = isRaspored ? termini.count : treninziClanarine.count;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Ponuda",
      selectedIndex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          _tabs(),
          const SizedBox(height: 30),
          Container(child: _searchWidgets()),
          const SizedBox(height: 10),
          Expanded(child: _buildDataListView()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 630),
            child: ElevatedButton(
              onPressed: () {
                isRaspored ? _showAddTerminDialog() : _showAddStavkuDialog();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 159, 160, 255),
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
              child: isRaspored
                  ? const Text('Dodaj termin')
                  : const Text('Dodaj stavku'),
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
                isSearching ? getFiltriraneTermine() : _loadData();
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

  Widget _tabs() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isRaspored = true;
                _selectedList = _terminiList;
              });
              getFiltriraneTermine();
            },
            child: Text(
              'Raspored',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isRaspored ? Colors.blue : Colors.grey),
            ),
          ),
          const SizedBox(width: 10),
          const Text('|'),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                isRaspored = false;
                _selectedList = _treninziClanarineList;
              });
              getFiltriraneTermine();
            },
            child: Text(
              'Cjenovnik',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isRaspored ? Colors.grey : Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    int counter = 1;
    return Container(
      height: 700,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 300),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              child: ListView.builder(
                  itemCount: _selectedList.length,
                  itemBuilder: (context, index) {
                    final e = _selectedList[index];
                    final currentNumber = counter++;
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 20),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          title: isRaspored
                              ? Row(
                                  children: [
                                    Text(
                                      '$currentNumber.',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(0, 154, 231, 1),
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Text(
                                      e.dan + ' u ' + e.sat,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Color.fromRGBO(0, 154, 231, 1),
                                      ),
                                    ),
                                    const Text('   |   '),
                                    FutureBuilder<dynamic>(
                                      future: _treninziProvider
                                          .getById(e.treningId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final trening = snapshot.data;
                                            if (trening != null) {
                                              return Text(
                                                trening.naziv,
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
                                    ),
                                    const Text('   |   '),
                                    FutureBuilder<dynamic>(
                                      future:
                                          _treneriProvider.getById(e.trenerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final trener = snapshot.data;
                                            if (trener != null) {
                                              return Text(
                                                trener.ime +
                                                    ' ' +
                                                    trener.prezime,
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
                                    ),
                                    const Text('   |   '),
                                    FutureBuilder<dynamic>(
                                      future: _saleProvider.getById(e.salaId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final sala = snapshot.data;
                                            if (sala != null) {
                                              return Text(
                                                sala.naziv,
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
                                    ),
                                    const Text('   |   '),
                                    if (e.brojClanova != null)
                                      Text(
                                        '${e.brojClanova} članova',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Color.fromRGBO(0, 154, 231, 1),
                                        ),
                                      )
                                    else
                                      const Text('')
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      '$currentNumber.',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(0, 154, 231, 1),
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    FutureBuilder<dynamic>(
                                      future: _vrsteTreningaProvider
                                          .getById(e.vrstaTreningaId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final trening = snapshot.data;
                                            if (trening != null) {
                                              return Text(
                                                trening.naziv,
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
                                    ),
                                    const Text('   |   '),
                                    if (e.ucestalost != null)
                                      Text(
                                        '${e.ucestalost} x',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Color.fromRGBO(0, 154, 231, 1),
                                        ),
                                      )
                                    else
                                      const Text(''),
                                    const Text('   |   '),
                                    Text(
                                      '${e.cijena} KM',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Color.fromRGBO(0, 154, 231, 1),
                                      ),
                                    )
                                  ],
                                ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: "Uredi",
                                textStyle: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    isRaspored
                                        ? showEditTermin(e)
                                        : showEditStavku(e);
                                  },
                                ),
                              ),
                              Tooltip(
                                message: "Obriši",
                                textStyle: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    isRaspored
                                        ? _confirmDeleteTermin(
                                            context, e.terminId)
                                        : _confirmDeleteStavku(
                                            context, e.treningClanarinaId);
                                  },
                                ),
                              )
                            ],
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
          child: isRaspored
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Radni dani",
                          suffixIcon: _selectedDan != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedDan = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        value: _selectedDan,
                        items: radniDani.map((String dan) {
                          return DropdownMenuItem(
                            value: dan,
                            child: Text(dan),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDan = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                          labelText: "Treninzi",
                          suffixIcon: _selectedTrening != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTrening = null;
                                    });
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
                          setState(() {
                            _selectedTrening = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                          labelText: "Treneri",
                          suffixIcon: _selectedTrener != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTrener = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        value: _selectedTrener,
                        items: _treneriList.map((Treneri trener) {
                          return DropdownMenuItem(
                            value: trener.trenerId,
                            child: Text('${trener.ime} ${trener.prezime}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTrener = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                          labelText: "Sale",
                          suffixIcon: _selectedSala != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedSala = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        value: _selectedSala,
                        items: _saleList.map((Sale sala) {
                          return DropdownMenuItem(
                            value: sala.salaId,
                            child: Text(sala.naziv),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSala = value;
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
                            await getFiltriraneTermine();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 3, 59, 227),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 17),
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Pretraži"),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                          labelText: "Treninzi",
                          suffixIcon: _selectedVrstaTr != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedVrstaTr = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        value: _selectedVrstaTr,
                        items: _vrsteTreningaList.map((VrsteTreninga trening) {
                          return DropdownMenuItem(
                            value: trening.vrstaTreningaId,
                            child: Text(trening.naziv!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVrstaTr = value as int?;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                          labelText: "Članarine",
                          suffixIcon: _selectedClanarina != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedClanarina = null;
                                    });
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
                          setState(() {
                            _selectedClanarina = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Učestalost",
                          suffixIcon: _selectedUcestalost != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedUcestalost = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        value: _selectedUcestalost,
                        items: ucestalost.map((String u) {
                          return DropdownMenuItem(
                            value: u,
                            child: Text(u),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUcestalost = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Cijena (KM)",
                          suffixIcon: _cijenaController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _cijenaController.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        controller: _cijenaController,
                        keyboardType:
                            TextInputType.number, // Ako očekujete samo brojeve
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50, right: 80),
                        child: ElevatedButton(
                          onPressed: () async {
                            await getFiltriraneTermine();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 3, 59, 227),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 17),
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Pretraži"),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }

  Future<void> getFiltriraneTermine() async {
    isSearching = true;
    var data1 = await _terminiProvider.get(filter: {
      'dan': _selectedDan,
      'trenerId': _selectedTrener,
      'treningId': _selectedTrening,
      'salaId': _selectedSala,
      'page': page,
      'pageSize': pageSize
    });

    var data2 = await _treninziClanarineProvider.get(filter: {
      'vrstaTreningaId': _selectedVrstaTr,
      'clanarinaId': _selectedClanarina,
      'ucestalost': _selectedUcestalost != null
          ? int.parse(_selectedUcestalost![0])
          : null,
      'cijena': int.tryParse(_cijenaController.text),
      'page': page,
      'pageSize': pageSize
    });

    setState(() {
      _terminiList = data1.result;
      _treninziClanarineList = data2.result;

      if (isRaspored) {
        _selectedList = _terminiList;
        totalcount = data1.count;
      } else {
        _selectedList = _treninziClanarineList;
        totalcount = data2.count;
      }
    });
  }

  void _confirmDeleteTermin(BuildContext context, int id) {
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
          content:
              const Text('Da li ste sigurni da želite izbrisati ovaj termin?'),
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
                _obrisiTermin(id);
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

  void _obrisiTermin(int terminId) async {
    try {
      await _terminiProvider.delete(terminId);
      _showAlertDialog(
          "Uspješno brisanje", "Termin uspješno izbrisan.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _confirmDeleteStavku(BuildContext context, int id) {
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
              'Da li ste sigurni da želite izbrisati ovu stavku sa cjenovnika?'),
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
                _obrisiStavku(id);
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

  void _obrisiStavku(int id) async {
    try {
      await _treninziClanarineProvider.delete(id);
      _showAlertDialog(
          "Uspješno brisanje", "Stavka uspješno izbrisana.", Colors.green);
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
              primary: Colors.blue,
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

  void _showAddTerminDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj termin'),
          content: Container(
            width: 400.0,
            height: 500.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      name: 'dan',
                      decoration:
                          const InputDecoration(labelText: 'Radni dani'),
                      initialValue: radniDani[0],
                      items: radniDani.map((dan) {
                        return DropdownMenuItem(
                          value: dan,
                          child: Text(dan),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'sat',
                      decoration: const InputDecoration(labelText: 'Sat'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (value.length < 5) {
                          return 'Ovo polje može imati minimalno 4 karaktera.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'brojClanova',
                      decoration:
                          const InputDecoration(labelText: 'Broj članova'),
                      validator: (value) {
                        if (value != null && value.length > 2) {
                          return 'Ovo polje može sadržavati jednu ili dvije cifre.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'treningId',
                      decoration: const InputDecoration(labelText: 'Trening'),
                      initialValue: _treninziList[0].treningId,
                      items: _treninziList.map((trening) {
                        return DropdownMenuItem(
                          value: trening.treningId,
                          child: Text(trening.naziv),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'trenerId',
                      decoration: const InputDecoration(labelText: 'Trener'),
                      initialValue: _treneriList[0].trenerId,
                      items: _treneriList.map((trener) {
                        return DropdownMenuItem(
                          value: trener.trenerId,
                          child: Text('${trener.ime} ${trener.prezime}'),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'salaId',
                      decoration: const InputDecoration(labelText: 'Sala'),
                      initialValue: _saleList[0].salaId,
                      items: _saleList.map((sala) {
                        return DropdownMenuItem(
                          value: sala.salaId,
                          child: Text(sala.naziv),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _dodajTermin();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0, 154, 231, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Spremi'),
            ),
          ],
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }

  void _dodajTermin() {
    _formKey.currentState?.saveAndValidate();
    final currentFormState = _formKey.currentState;
    if (!_areAllFieldsFilled(currentFormState)) {
      _showAlertDialog(
          "Upozorenje", "Popunite sva obavezna polja.", Colors.orange);
      return;
    }
    if (currentFormState != null) {
      if (!currentFormState.validate()) {
        _showAlertDialog(
            "Upozorenje",
            "Molimo vas da ispravno popunite sva obavezna polja.",
            Colors.orange);
        return;
      }
    }
    var request = Map.from(_formKey.currentState!.value);
    try {
      _terminiProvider.insert(request);
      _showAlertDialog("Uspješan unos", "Termin uspješno dodan.", Colors.green);
    } on Exception catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = ['dan', 'treningId', 'trenerId', 'salaId'];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
  }

  void _showAddStavkuDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj stavku'),
          content: Container(
            width: 400.0,
            height: 500.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey2,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      name: 'vrstaTreningaId',
                      decoration:
                          const InputDecoration(labelText: 'Vrsta treninga'),
                      initialValue: _vrsteTreningaList[0].vrstaTreningaId,
                      items: _vrsteTreningaList.map((trening) {
                        return DropdownMenuItem(
                          value: trening.vrstaTreningaId,
                          child: Text(trening.naziv!),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'clanarinaId',
                      decoration: const InputDecoration(labelText: 'Članarina'),
                      initialValue: _clanarineList[0].clanarinaId,
                      items: _clanarineList.map((clanarina) {
                        return DropdownMenuItem(
                          value: clanarina.clanarinaId,
                          child: Text(clanarina.naziv),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'ucestalost',
                      decoration:
                          const InputDecoration(labelText: 'Učestalost'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (!RegExp(r'^[1-5]$').hasMatch(value)) {
                          return 'Ovo polje može sadržavati samo brojeve od 1 do 5.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'cijena',
                      decoration: const InputDecoration(labelText: 'Cijena'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Ovo polje može sadržavati samo brojeve.';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _dodajStavku();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0, 154, 231, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Spremi'),
            ),
          ],
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }

  void _dodajStavku() {
    _formKey2.currentState?.saveAndValidate();
    final currentFormState = _formKey2.currentState;
    if (!_areAllFieldsFilled2(currentFormState)) {
      _showAlertDialog(
          "Upozorenje", "Popunite sva obavezna polja.", Colors.orange);
      return;
    }
    if (currentFormState != null) {
      if (!currentFormState.validate()) {
        _showAlertDialog(
            "Upozorenje",
            "Molimo vas da ispravno popunite sva obavezna polja.",
            Colors.orange);
        return;
      }
    }
    var request = Map.from(_formKey2.currentState!.value);
    try {
      _treninziClanarineProvider.insert(request);
      _showAlertDialog("Uspješan unos", "Stavka uspješno dodana na cjenovnik.",
          Colors.green);
    } on Exception catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  bool _areAllFieldsFilled2(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = [
      'cijena',
      'clanarinaId',
      'vrstaTreningaId',
      'ucestalost'
    ];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
  }

  showEditTermin(Termini termin) async {
    final TextEditingController satController =
        TextEditingController(text: termin.sat);
    final TextEditingController brojClanovaController =
        TextEditingController(text: termin.brojClanova.toString());

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj termin'),
                content: SingleChildScrollView(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(children: [
                    FormBuilder(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 800),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderDropdown(
                                            name: 'dan',
                                            decoration: const InputDecoration(
                                                labelText: 'Radni dani'),
                                            initialValue: termin.dan,
                                            items: radniDani.map((dan) {
                                              return DropdownMenuItem(
                                                value: dan,
                                                child: Text(dan),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDan = value as String?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 10.0),
                                          FormBuilderTextField(
                                            name: 'sat',
                                            controller: satController,
                                            decoration: const InputDecoration(
                                                labelText: 'Sat'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (value.length < 5) {
                                                return 'Ovo polje može imati minimalno 4 karaktera.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'brojClanova',
                                            controller: brojClanovaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Broj članova',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  value.length > 2) {
                                                return 'Ovo polje može sadržavati jednu ili dvije cifre.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderDropdown(
                                            name: 'treningId',
                                            decoration: const InputDecoration(
                                                labelText: 'Trening'),
                                            initialValue: termin.treningId,
                                            items: _treninziList.map((trening) {
                                              return DropdownMenuItem(
                                                value: trening.treningId,
                                                child: Text(trening.naziv),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedTrening =
                                                    value as int?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 10.0),
                                          FormBuilderDropdown(
                                            name: 'trenerId',
                                            decoration: const InputDecoration(
                                                labelText: 'Trener'),
                                            initialValue: termin.trenerId,
                                            items: _treneriList.map((trener) {
                                              return DropdownMenuItem(
                                                value: trener.trenerId,
                                                child: Text(
                                                    '${trener.ime} ${trener.prezime}'),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedTrener = value as int?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 10.0),
                                          FormBuilderDropdown(
                                            name: 'salaId',
                                            decoration: const InputDecoration(
                                                labelText: 'Sala'),
                                            initialValue: termin.salaId,
                                            items: _saleList.map((sala) {
                                              return DropdownMenuItem(
                                                value: sala.salaId,
                                                child: Text(sala.naziv),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedSala = value as int?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                Termini t = Termini(
                                                    terminId: termin.terminId,
                                                    dan: _selectedDan ??
                                                        termin.dan,
                                                    sat: satController.text,
                                                    brojClanova: int.tryParse(
                                                            brojClanovaController
                                                                .text) ??
                                                        0,
                                                    treningId:
                                                        _selectedTrening ??
                                                            termin.treningId,
                                                    trenerId: _selectedTrener ??
                                                        termin.trenerId,
                                                    salaId: _selectedSala ??
                                                        termin.salaId);

                                                _terminiProvider.update(
                                                    termin.terminId, t);
                                                _showAlertDialog(
                                                    "Uspješan edit",
                                                    "Podaci o terminu uspješno ažurirani.",
                                                    Colors.green);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color.fromRGBO(
                                                  0, 154, 231, 1),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            child: const Text('Sačuvaj'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                            ]),
                      ),
                    )
                  ]),
                )));
          });
        });
  }

  showEditStavku(TreninziClanarine stavka) async {
    final TextEditingController ucestalostController =
        TextEditingController(text: stavka.ucestalost.toString());
    final TextEditingController cijenaController =
        TextEditingController(text: stavka.cijena.toString());

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj stavku'),
                content: SingleChildScrollView(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(children: [
                    FormBuilder(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 800),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderDropdown(
                                            name: 'vrstaTreningaId',
                                            decoration: const InputDecoration(
                                                labelText: 'Vrsta treninga'),
                                            initialValue:
                                                stavka.vrstaTreningaId,
                                            items: _vrsteTreningaList
                                                .map((trening) {
                                              return DropdownMenuItem(
                                                value: trening.vrstaTreningaId,
                                                child: Text(trening.naziv!),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedVrstaTr =
                                                    value as int?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 10.0),
                                          FormBuilderDropdown(
                                            name: 'clanarinaId',
                                            decoration: const InputDecoration(
                                                labelText: 'Članarina'),
                                            initialValue: stavka.clanarinaId,
                                            items:
                                                _clanarineList.map((clanarina) {
                                              return DropdownMenuItem(
                                                value: clanarina.clanarinaId,
                                                child: Text(clanarina.naziv),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedClanarina =
                                                    value as int?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 10.0),
                                          FormBuilderTextField(
                                            name: 'ucestalost',
                                            controller: ucestalostController,
                                            decoration: const InputDecoration(
                                                labelText: 'Učestalost'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (!RegExp(r'^[1-5]$')
                                                  .hasMatch(value)) {
                                                return 'Ovo polje može sadržavati samo brojeve od 1 do 5.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'cijena',
                                            controller: cijenaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Cijena',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (!RegExp(r'^[0-9]+$')
                                                  .hasMatch(value)) {
                                                return 'Ovo polje može sadržavati samo brojeve.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                TreninziClanarine tc = TreninziClanarine(
                                                    treningClanarinaId: stavka
                                                        .treningClanarinaId,
                                                    vrstaTreningaId:
                                                        _selectedVrstaTr ??
                                                            stavka
                                                                .vrstaTreningaId,
                                                    clanarinaId:
                                                        _selectedClanarina ??
                                                            stavka.clanarinaId,
                                                    ucestalost: int.tryParse(
                                                            ucestalostController
                                                                .text) ??
                                                        0,
                                                    cijena: int.tryParse(
                                                            cijenaController
                                                                .text) ??
                                                        0);

                                                _treninziClanarineProvider
                                                    .update(
                                                        stavka
                                                            .treningClanarinaId,
                                                        tc);
                                                _showAlertDialog(
                                                    "Uspješan edit",
                                                    "Podaci o stavci uspješno ažurirani.",
                                                    Colors.green);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color.fromRGBO(
                                                  0, 154, 231, 1),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            child: const Text('Sačuvaj'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                            ]),
                      ),
                    )
                  ]),
                )));
          });
        });
  }
}
