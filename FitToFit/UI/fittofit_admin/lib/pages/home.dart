import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/novosti.dart';
import 'package:fittofit_admin/models/search_result.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/pages/novosti_detalji.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/rezervacije_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
import '../widgets/master_screen.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NovostiProvider _novostiProvider;
  late KorisniciProvider _korisniciProvider;
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreneriProvider _treneriProvider;
  late RezervacijeProvider _rezervacijeProvider;
  SearchResult<Novosti>? result;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<VrsteTreninga>? vrsteTreningaResult;
  SearchResult<Treneri>? treneriResult;
  final TextEditingController _naslovController = TextEditingController();
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Novosti> _novostiList = [];
  int? _selectedVrstaTreninga;
  int brojKorisnika = 0;
  int brojTrenera = 0;
  int brojRezervacija = 0;

  DateTime? datum;
  late Korisnici logiraniKorisnik;
  String korisnickoIme = '';
  final _formKey = GlobalKey<FormBuilderState>();
  bool isSearching = false;
  FocusNode _naslovFocusNode = FocusNode();

  var page = 1;
  var totalcount = 0;
  var pageSize = 6;

  @override
  void initState() {
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _loadData();
    _novostiProvider.addListener(() {
      _reloadNovostiList();
      setTotalItems();
    });
    korisnickoIme = widget.username;
    _naslovFocusNode = FocusNode();
  }

  void setTotalItems() async {
    var novostiResult = await _novostiProvider
        .get(filter: {'page': page, 'pageSize': pageSize});

    if (mounted) {
      setState(() {
        totalcount = novostiResult.count;
      });

      int totalPages = (totalcount / pageSize).ceil();

      if (page >= totalPages && totalPages > 0) {
        setState(() {
          page--;
        });
      }
      _reloadNovostiList();
    }
  }

  void _reloadNovostiList() async {
    var novosti = await _novostiProvider
        .get(filter: {'page': page, 'pageSize': pageSize});
    if (mounted) {
      setState(() {
        _novostiList = novosti.result;
      });
    }
  }

  @override
  void dispose() {
    _naslovFocusNode.dispose();
    super.dispose();
  }

  void _loadData() async {
    if (!mounted) return;
    isSearching = false;
    var korisnici = await _korisniciProvider.get(filter: {'isAdmin': false});
    var treneri = await _treneriProvider.get(filter: {});
    var rezervacije =
        await _rezervacijeProvider.get(filter: {'StateMachine': 'active'});
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
    var korisnik = await _korisniciProvider
        .get(filter: {'isAdmin': true, 'KorisnickoIme': korisnickoIme});
    var novosti = await _novostiProvider
        .get(filter: {'page': page, 'pageSize': pageSize});

    setState(() {
      brojKorisnika = korisnici.count;
      brojTrenera = treneri.count;
      brojRezervacija = rezervacije.count;
      _vrsteTreningaList = vrsteTreninga.result;
      logiraniKorisnik = korisnik.result[0];
      _novostiList = novosti.result;
      totalcount = novosti.count;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Početna",
        selectedIndex: 0,
        showBackArrow: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddNewsDialog();
          },
          backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [Dashboard()],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 1.0,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildSearch(),
                  _buildDataListView(),
                  _buildPageNumbers()
                ],
              ),
            ),
          ],
        ));
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
                isSearching ? _getFilteredNews() : _loadData();
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

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(labelText: "Naslov"),
            controller: _naslovController,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Vrsta treninga",
              suffixIcon: _selectedVrstaTreninga != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedVrstaTreninga = null;
                          _loadData();
                        });
                      },
                    )
                  : null,
            ),
            value: _selectedVrstaTreninga,
            items: _vrsteTreningaList.map((VrsteTreninga vrsta) {
              return DropdownMenuItem(
                value: vrsta.vrstaTreningaId,
                child: Text(vrsta.naziv!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedVrstaTreninga = value;
                _loadData();
              });
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () async {
            await _getFilteredNews();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            side: const BorderSide(color: Colors.white),
          ),
          child: const Text("Pretraži"),
        )
      ]),
    );
  }

  Future<void> _getFilteredNews() async {
    isSearching = true;
    var data = await _novostiProvider.get(filter: {
      'naslov': _naslovController.text,
      'vrstaTreningaId': _selectedVrstaTreninga,
      'page': page,
      'pageSize': pageSize
    });

    setState(() {
      _novostiList = data.result;
      totalcount = data.count;
    });
  }

  Expanded _buildDataListView() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        child: ListView.builder(
            itemCount: _novostiList.length,
            itemBuilder: (context, index) {
              final e = _novostiList[index];
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      title: Row(
                        children: [
                          Text(
                            e.naslov,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color.fromRGBO(0, 154, 231, 1),
                            ),
                          ),
                          const Text('   |   '),
                          Text(
                            formatDate(e.datumObjave),
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Color.fromRGBO(0, 154, 231, 1),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5.0),
                          Text(
                            e.sadrzaj != null && e.sadrzaj!.length > 80
                                ? '${e.sadrzaj!.substring(0, 80)}...'
                                : e.sadrzaj ?? '',
                          ),
                        ],
                      ),
                      trailing: Container(
                        margin: const EdgeInsets.only(right: 30.0),
                        child: const Text(
                          '>',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Color.fromRGBO(0, 154, 231, 1),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NovostiDetaljiPage(
                              novost: e,
                              adminId: logiraniKorisnik.korisnikId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0)
                ],
              );
            }),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Dashboard() {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 40),
            child: Text(
              "Dashboard",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: "ProtestRevoulution",
                  color: Colors.black54.withBlue(70)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First block
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: MediaQuery.of(context).size.width * 0.22,
                height: 200,
                child: DashboardBlock(
                    color: const Color.fromARGB(255, 160, 203, 255),
                    title: 'BROJ KORISNIKA',
                    content: brojKorisnika.toString()),
              ),
              // Second block
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.22,
                  height: 200,
                  child: DashboardBlock(
                      color: const Color.fromARGB(255, 242, 239, 152),
                      title: 'BROJ TRENERA',
                      content: brojTrenera.toString())),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Third block
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 140,
                  child: DashboardBlock(
                      color: const Color.fromARGB(255, 248, 166, 133),
                      title: 'TRENUTNO AKTIVNIH REZERVACIJA',
                      content: brojRezervacija.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNewsDialog() {
    int? selectedVrstaTreninga;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_naslovFocusNode);
        });
        return AlertDialog(
          title: const Text('Dodaj novost'),
          content: Container(
            width: 400.0,
            height: 400.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'naslov',
                      focusNode: _naslovFocusNode,
                      decoration: const InputDecoration(labelText: 'Naslov'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'sadrzaj',
                      decoration: const InputDecoration(labelText: 'Sadrzaj'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno.';
                        } else if (value.length < 5) {
                          return 'Morate unijeti najmanje 5 karaktera.';
                        } else if (value.length > 600) {
                          return 'Premašili ste maksimalan broj karaktera.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        backgroundColor:
                            const Color.fromARGB(255, 208, 207, 207),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date == null) {
                          _showAlertDialog("Pažnja!",
                              "Datum objave je obavezan.", Colors.red);
                        } else {
                          setState(() {
                            datum = date;
                          });
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Izaberite datum objave",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    datum != null
                        ? Text(
                            "Izabrani datum: $datum",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'vrstaTreningaId',
                      decoration: const InputDecoration(
                          labelText: 'Vrsta treninga',
                          hintText: 'Odaberite vrstu treninga'),
                      initialValue: selectedVrstaTreninga,
                      items: _vrsteTreningaList.map((vrstaTreninga) {
                        return DropdownMenuItem(
                          value: vrstaTreninga.vrstaTreningaId,
                          child: Text(vrstaTreninga.naziv!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedVrstaTreninga = value;
                        });
                      },
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
                _dodajNovost();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
                foregroundColor: Colors.white,
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

  void _dodajNovost() {
    if (datum == null) {
      _showAlertDialog("Pažnja!", "Datum objave je obavezan.", Colors.red);
      return;
    }
    String _datum = datum.toString();
    String datumVrijeme =
        DateTime.parse(_datum.replaceAll(' ', 'T')).toIso8601String();
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
    request['brojLajkova'] = 0;
    request['korisnikId'] = logiraniKorisnik.korisnikId;
    request.addAll({
      'datumObjave': datumVrijeme,
    });
    try {
      _novostiProvider.insert(request);
      datum = null;
      _showAlertDialog(
          "Uspješan unos", "Novost uspješno dodana.", Colors.green);
    } on Exception catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = ['naslov', 'sadrzaj'];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
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
}

class DashboardBlock extends StatelessWidget {
  final Color color;
  final String title;
  final String content;
  final Color textColor;

  const DashboardBlock(
      {required this.color,
      required this.title,
      required this.content,
      this.textColor = const Color.fromARGB(255, 2, 0, 38)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
                fontSize: 60, fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
