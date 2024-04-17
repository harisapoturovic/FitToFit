import 'package:fittofit_admin/models/acTrening.dart';
import 'package:fittofit_admin/models/clanarine.dart';
import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/rezervacije.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/providers/clanarine_provider.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/rezervacije_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
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
  List<Rezervacije> _arhiviraneRezervacijeList = [];
  List<Rezervacije> _draftRezervacijeList = [];
  List<Rezervacije> _selectedRezervacije = [];
  List<Rezervacije> _rezervacijeList = [];
  List<Korisnici> _korisniciList = [];
  List<Treninzi> _treninziList = [];
  List<Clanarine> _clanarineList = [];
  DateTime? _selectedDate;
  int? _selectedKorisnik;
  int? _selectedTrening;
  int? _selectedClanarina;
  List<String> nazivList = [];
  late AcTrening acTrening;
  List<int>? items;
  bool isActive = true;

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
    var aktivneRezervacije = await _rezervacijeProvider
        .get(filter: {'IsTerminiIncluded': true, 'StateMachine': "active"});

    var arhiviraneRezervacije = await _rezervacijeProvider
        .get(filter: {'IsTerminiIncluded': true, 'StateMachine': "archived"});

    var draftRezervacije = await _rezervacijeProvider
        .get(filter: {'IsTerminiIncluded': true, 'StateMachine': "draft"});
    var korisnici = await _korisniciProvider.get(filter: {'isAdmin': false});
    var treninzi = await _treninziProvider.get(filter: {});
    var clanarine = await _clanarineProvider.get(filter: {});
    var rezervacije = await _rezervacijeProvider.get(filter: {});

    setState(() {
      _aktivneRezervacijeList = aktivneRezervacije.result;
      _arhiviraneRezervacijeList = arhiviraneRezervacije.result;
      _draftRezervacijeList = draftRezervacije.result;
      _selectedRezervacije = _aktivneRezervacijeList;
      _korisniciList = korisnici.result;
      _treninziList = treninzi.result;
      _clanarineList = clanarine.result;
      _rezervacijeList=rezervacije.result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Rezervacije",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Expanded(child: _searchWidgets()),
          const SizedBox(height: 10),
         _buildDataListView()
        ],
      ),
    );
  }

  String formatDate(DateTime? dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime!);
  }

  Expanded _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            children: _rezervacijeList
                .map((Rezervacije e) => Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 250.0),
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
                                  e.korisnikId.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(0, 154, 231, 1),
                                  ),
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
                                Text(
                                 e.clanarinaId.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(0, 154, 231, 1),
                                  ),
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
                              
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0)
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _searchWidgets() {
    return Container(
      color: const Color.fromARGB(255, 78, 101, 214).withOpacity(0.1), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Korisnici"),
                items: _korisniciList.map((Korisnici korisnik) {
                  return DropdownMenuItem(
                    value: korisnik.korisnikId,
                    child: Text('${korisnik.ime} ${korisnik.prezime}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKorisnik = value as int?;
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
                    decoration: const InputDecoration(labelText: 'Datum'),
                    format: DateFormat("yyyy-MM-dd"),
                    initialDate: _selectedDate ?? DateTime.now(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDate = value;
                      });
                    }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Treninzi"),
                items: _treninziList.map((Treninzi trening) {
                  return DropdownMenuItem(
                    value: trening.treningId,
                    child: Text(trening.naziv),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTrening = value as int?;
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Članarine"),
                items: _clanarineList.map((Clanarine clanarina) {
                  return DropdownMenuItem(
                    value: clanarina.clanarinaId,
                    child: Text(clanarina.naziv),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClanarina = value as int?;
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
                    var data1 = await _rezervacijeProvider.get(filter: {
                      'datum': _selectedDate,
                      'korisnikId': _selectedKorisnik,
                      'clanarinaId': _selectedClanarina,
                      'treningId':_selectedTrening
                    });

                    var data2 = await _rezervacijeProvider.get(filter: {
                      'datum': _selectedDate,
                      'korisnikId': _selectedKorisnik,
                      'clanarinaId': _selectedClanarina,
                      'stateMachine': "archived"
                    });

                    var data3 = await _rezervacijeProvider.get(filter: {
                      'datum': _selectedDate,
                      'korisnikId': _selectedKorisnik,
                      'clanarinaId': _selectedClanarina,
                      'stateMachine': "draft"
                    });

                    setState(() {
                      _aktivneRezervacijeList = data1.result;
                      _arhiviraneRezervacijeList = data2.result;
                      _draftRezervacijeList = data3.result;
                      _rezervacijeList=data1.result;
                      //if (isActive) {
                      //  _selectedRezervacije = _aktivneRezervacijeList;
                      //} else {
                      //  _selectedRezervacije = _draftRezervacijeList;
                      //}
                      _selectedRezervacije=_rezervacijeList;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 3, 59, 227),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Pretraži"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _listOfActiveReservations() {
    ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isActive = true;
                    _selectedRezervacije = _aktivneRezervacijeList;
                  });
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
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: _selectedRezervacije.map((rezervacija) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 225, 225, 225),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          //child: AkcijeCard(akcija: rezervacija),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listOfArchivedReservations() {
    ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Arhiva',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 94, 94)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                children: _arhiviraneRezervacijeList.map((rezervacija) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 225, 225, 225),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        //child: AkcijeCard(akcija: akcija)
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
