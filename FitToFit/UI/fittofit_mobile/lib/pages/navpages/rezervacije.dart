import 'package:fittofit_mobile/models/clanarine.dart';
import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/models/rezervacijeRequest.dart';
import 'package:fittofit_mobile/models/search_result.dart';
import 'package:fittofit_mobile/models/termini.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/models/treninziClanarine.dart';
import 'package:fittofit_mobile/models/vrste_treninga.dart';
import 'package:fittofit_mobile/providers/clanarine_provider.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/providers/rezervacije_provider.dart';
import 'package:fittofit_mobile/providers/termini_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_clanarine_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_provider.dart';
import 'package:fittofit_mobile/providers/vrste_treninga_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReservationPage extends StatefulWidget {
  final int selectedIndex;
  const ReservationPage({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late ClanarineProvider _clanarineProvider;
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreninziProvider _treninziProvider;
  late TerminiProvider _terminiProvider;
  late RezervacijeProvider _rezervacijeProvider;
  late KorisniciProvider _korisniciProvider;
  late TreninziClanarineProvider _treninziClanarineProvider;
  List<Clanarine> _clanarineList = [];
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  List<Termini> _terminiList = [];
  List<Termini> _termin = [];
  List<TreninziClanarine> _treninziClanarineList = [];
  int? _rezervacijeCount;
  List<int> _terminiIds = [];
  int? _selectedClanarina;
  int? _selectedVrstaTreninga;
  int? _selectedTrening;
  String? korisnickoIme = '';
  late Korisnici korisnik;

  @override
  void initState() {
    super.initState();
    _clanarineProvider = context.read<ClanarineProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _terminiProvider = context.read<TerminiProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _treninziClanarineProvider = context.read<TreninziClanarineProvider>();
    _loadData();
  }

  void _loadData() async {
    var clanarine = await _clanarineProvider.get(filter: {});
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
    var treninzi = await _treninziProvider
        .get(filter: {'vrstaTreninga': _selectedVrstaTreninga});
    korisnickoIme = await getUserName();
    var user = await _korisniciProvider
        .get(filter: {'korisnickoIme': korisnickoIme, 'isAdmin': false});

    setState(() {
      _clanarineList = clanarine.result;
      _vrsteTreningaList = vrsteTreninga.result;
      _treninziList = treninzi.result;
      korisnik = user.result[0];
    });
    if (_selectedTrening != null) {
      var termini =
          await _terminiProvider.get(filter: {'treningId': _selectedTrening});
      setState(() {
        _terminiList = termini.result;
      });
    }
    if (user != null) {
      var rezervacije = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'active'
      });
      setState(() {
        _rezervacijeCount = rezervacije.count;
      });
    }
  }

  void _loadCjenovnik() async {
    if (_selectedVrstaTreninga != null &&
        _selectedClanarina != null &&
        _terminiIds.isNotEmpty) {
      var cjenovnik = await _treninziClanarineProvider.get(filter: {
        'vrstaTreningaId': _selectedVrstaTreninga,
        'clanarinaId': _selectedClanarina,
        'ucestalost': _terminiIds.length
      });
      setState(() {
        _treninziClanarineList = cjenovnik.result;
      });
    }
  }

  Future<List<Termini>> getTermineByTreningId(int treningId) async {
    final termini =
        await _terminiProvider.get(filter: {'treningId': treningId});
    return termini.result;
  }

  Map<String, List<Termini>> _grupisiTerminePoDanu(List<Termini> terminiList) {
    Map<String, List<Termini>> groupedByDay = {};
    terminiList.forEach((termin) {
      String day = termin.dan;
      if (!groupedByDay.containsKey(day)) {
        groupedByDay[day] = [];
      }
      groupedByDay[day]!.add(termin);
    });
    return groupedByDay;
  }

  String formatDate(DateTime? dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime!);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 2,
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Rezervacije'),
              backgroundColor: Colors.deepPurple.shade300),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
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
                  SizedBox(
                    height: 80,
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(labelText: "Vrste treninga"),
                      items:
                          _vrsteTreningaList.map((VrsteTreninga vrsteTreninga) {
                        return DropdownMenuItem(
                          value: vrsteTreninga.vrstaTreningaId,
                          child: Text(vrsteTreninga.naziv!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedVrstaTreninga = value as int?;
                        });
                        _loadData();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 80,
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
                        _loadData();
                      },
                    ),
                  ),
                  if (_terminiList.isNotEmpty)
                    Expanded(
                      child: ListView(
                        children: _buildGroupedTermine(),
                      ),
                    ),
                  if (_terminiList.isEmpty)
                    const Center(
                      child:
                          Text('Nema dostupnih termina za odabrani trening.'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      int korisnikId = korisnik.korisnikId;
                      int clanarinaId = _selectedClanarina!;
                      List<int> terminIds = _terminiIds;
                      DateTime now = DateTime.now();

                      String formattedDate =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                              .format(now.toUtc());

                      List<RezervacijeItem> items = terminIds
                          .map(
                              (terminId) => RezervacijeItem(terminId: terminId))
                          .toList();

                      RezervacijeRequest request = RezervacijeRequest(
                        datum: formattedDate,
                        korisnikId: korisnikId,
                        clanarinaId: clanarinaId,
                        iznos: _treninziClanarineList[0].cijena,
                        items: items,
                      );
                      if (_rezervacijeCount! < 3) {
                        _rezervacijeProvider.insert(request.toJson());
                        _showAlertDialog("Rezervisano!",
                            "Uspješno kreirana rezervacija.", Colors.green);
                      } else {
                        _showAlertDialog(
                            "Greška",
                            "Napravili ste maksimalan broj rezervacija. Otkažite neku od njih ili sačekajte da istekne neka od prethodno rezervisanih.",
                            Colors.red);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Rezerviši',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  List<Widget> _buildGroupedTermine() {
    if (_terminiList.isNotEmpty) {
      Map<String, List<Termini>> groupedByDay =
          _grupisiTerminePoDanu(_terminiList);

      return groupedByDay.entries.map((entry) {
        String day = entry.key;
        List<Termini> terminiZaDan = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: terminiZaDan.map((termin) {
                bool isAvailable = termin.brojClanova! < 10;
                bool isFullyBooked = !isAvailable && termin.brojClanova == 10;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isAvailable) {
                          fetchData(day, termin);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        termin.sat ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isFullyBooked)
                      const Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'X',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> fetchData(String day, Termini termin) async {
    if (termin.brojClanova! < 10) {
      SearchResult<Termini> selectedTermin = await _terminiProvider.get(
          filter: {
            'dan': day,
            'sat': termin.sat,
            'treningId': _selectedTrening
          });

      setState(() {
        _termin = selectedTermin.result;
      });
      _terminiIds.add(_termin[0].terminId);
      _loadCjenovnik();
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
}
