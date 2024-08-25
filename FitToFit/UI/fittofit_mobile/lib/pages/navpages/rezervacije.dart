import 'dart:convert';

import 'package:fittofit_mobile/models/akcije.dart';
import 'package:fittofit_mobile/models/clanarine.dart';
import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/models/rezervacijeRequest.dart';
import 'package:fittofit_mobile/models/search_result.dart';
import 'package:fittofit_mobile/models/termini.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/models/treninziClanarine.dart';
import 'package:fittofit_mobile/models/vrste_treninga.dart';
import 'package:fittofit_mobile/providers/akcije_provider.dart';
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
import 'package:flutter_stripe/flutter_stripe.dart' as sp;
import 'package:http/http.dart' as http;

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
  late AkcijeProvider _akcijeProvider;
  List<Clanarine> _clanarineList = [];
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  List<Termini> _terminiList = [];
  List<Termini> _termin = [];
  late Treninzi _trening;
  List<TreninziClanarine> _treninziClanarineList = [];
  List<Akcije> _akcijeList = [];
  int? _rezervacijeCount1;
  int? _rezervacijeCount2;
  List<int> _terminiIds = [];
  int? _selectedClanarina;
  int? _selectedVrstaTreninga;
  int? _selectedTrening;
  String? korisnickoIme = '';
  late Korisnici korisnik;
  late Clanarine _clanarina;
  final Set<String> _selectedTermini = {};

  bool isLoading = true;
  int iznos = 0;
  Map<String, dynamic>? paymentIntent;

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
    _akcijeProvider = context.read<AkcijeProvider>();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    try {
      var clanarine = await _clanarineProvider.get(filter: {});
      var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
      var treninzi = await _treninziProvider.get(filter: {});
      korisnickoIme = await getUserName();
      var user = await _korisniciProvider
          .get(filter: {'korisnickoIme': korisnickoIme, 'isAdmin': false});

      if (mounted) {
        setState(() {
          _clanarineList = clanarine.result;
          _vrsteTreningaList = vrsteTreninga.result;
          _treninziList = treninzi.result;
          korisnik = user.result[0];
        });
      }

      if (_selectedVrstaTreninga != null) {
        var treninzi = await _treninziProvider
            .get(filter: {'vrstaTreninga': _selectedVrstaTreninga});
        if (mounted) {
          setState(() {
            _treninziList = treninzi.result;
          });
        }
      }

      if (_selectedTrening != null) {
        var termini =
            await _terminiProvider.get(filter: {'treningId': _selectedTrening});
        var trening = await _treninziProvider
            .get(filter: {'treningId': _selectedTrening});
        var akcije = await _akcijeProvider.get(
            filter: {'treningId': _selectedTrening, 'stateMachine': 'active'});
        if (mounted) {
          setState(() {
            _terminiList = termini.result;
            _trening = trening.result[0];
            _akcijeList = akcije.result;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _terminiList = [];
          });
        }
      }

      if (_selectedClanarina != null) {
        var clanarina = await _clanarineProvider
            .get(filter: {'clanarinaId': _selectedClanarina});
        if (mounted) {
          setState(() {
            _clanarina = clanarina.result[0];
          });
        }
      }

      var rezervacije1 = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'active'
      });
      var rezervacije2 = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'active',
        'treningId': _selectedTrening
      });
      if (mounted) {
        setState(() {
          _rezervacijeCount1 = rezervacije1.count;
          _rezervacijeCount2 = rezervacije2.count;
        });
      }
    } catch (e) {
      print(e.toString());
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

  Map<String, List<Termini>> _grupisiTerminePoDanu(List<Termini> terminiList) {
    Map<String, List<Termini>> groupedByDay = {};
    for (var termin in terminiList) {
      String day = termin.dan;
      if (!groupedByDay.containsKey(day)) {
        groupedByDay[day] = [];
      }
      groupedByDay[day]!.add(termin);
    }
    return groupedByDay;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Rezervacije'),
            backgroundColor: Colors.deepPurple.shade300,
            foregroundColor: Colors.white,
            leading: Container(),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Članarine",
                        suffixIcon: _selectedClanarina != null
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedClanarina = null;
                                    _loadData();
                                  });
                                },
                              )
                            : null,
                      ),
                      items: _clanarineList.map((Clanarine clanarina) {
                        return DropdownMenuItem<int>(
                          value: clanarina.clanarinaId,
                          child: Text(clanarina.naziv),
                        );
                      }).toList(),
                      value: _selectedClanarina,
                      onChanged: (value) {
                        setState(() {
                          _selectedClanarina = value;
                          _loadData();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Vrste treninga",
                        suffixIcon: _selectedVrstaTreninga != null
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedVrstaTreninga = null;
                                    _selectedTrening = null;
                                    _selectedTermini.clear();
                                    _terminiIds.clear();
                                    _loadData();
                                  });
                                },
                              )
                            : null,
                      ),
                      items:
                          _vrsteTreningaList.map((VrsteTreninga vrsteTreninga) {
                        return DropdownMenuItem<int>(
                          value: vrsteTreninga.vrstaTreningaId,
                          child: Text(vrsteTreninga.naziv!),
                        );
                      }).toList(),
                      value: _selectedVrstaTreninga,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedVrstaTreninga = value;
                          _selectedTrening = null;
                          _selectedTermini.clear();
                          _terminiIds.clear();
                          _loadData();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Treninzi",
                        suffixIcon: _selectedTrening != null
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedTrening = null;
                                    _selectedTermini.clear();
                                    _terminiIds.clear();
                                    _loadData();
                                  });
                                },
                              )
                            : null,
                      ),
                      items: _treninziList.map((Treninzi trening) {
                        return DropdownMenuItem<int>(
                          value: trening.treningId,
                          child: Text(trening.naziv),
                        );
                      }).toList(),
                      value: _selectedTrening,
                      onChanged: (value) {
                        setState(() {
                          _selectedTrening = value;
                          _selectedTermini.clear();
                          _terminiIds.clear();
                          _loadData();
                        });
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
                  _selectedClanarina != null &&
                          _selectedClanarina != 0 &&
                          _selectedTrening != null
                      ? ElevatedButton(
                          onPressed: () async {
                            _prikaziOdabrano();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                            minimumSize: const Size(120, 40),
                          ),
                          child: const Text(
                            'Dalje',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 30)
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
                bool isAvailable = termin.brojClanova < _trening.maxBrojClanova;
                bool isFullyBooked = !isAvailable &&
                    termin.brojClanova == _trening.maxBrojClanova;

                String key = '${day}_${termin.sat}';
                Color buttonColor = _selectedTermini.contains(key)
                    ? Colors.green
                    : Colors.purple.shade200;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isAvailable) {
                          setState(() {
                            if (_selectedTermini.contains(key)) {
                              _selectedTermini.remove(key);
                              _terminiIds.remove(termin.terminId);
                            } else {
                              _selectedTermini.add(key);
                              _terminiIds.add(termin.terminId);
                            }
                            _loadCjenovnik();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
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
                          alignment: Alignment.center,
                          child: Text(
                            'X',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
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
    SearchResult<Termini> selectedTermin = await _terminiProvider.get(
        filter: {'dan': day, 'sat': termin.sat, 'treningId': _selectedTrening});

    setState(() {
      _termin = selectedTermin.result;
    });
    if (_termin.isNotEmpty && !_terminiIds.contains(_termin[0].terminId)) {
      _terminiIds.add(_termin[0].terminId);
      _loadCjenovnik();
    } else {
      _showAlertDialog(
        "Greška",
        "Ne možete odabrati isti termin više puta.",
        Colors.red,
      );
    }
  }

  Future<Termini> fetchTermin(int terminId) async {
    var termin = await _terminiProvider.get(filter: {'terminId': terminId});

    return termin.result[0];
  }

  Future<String> _buildTermineText() async {
    List<String> termineTextList = [];

    for (var terminId in _terminiIds) {
      Termini fetchedTermin = await fetchTermin(terminId);

      String termText = "${fetchedTermin.dan} - ${fetchedTermin.sat}";

      termineTextList.add(termText);
    }
    return termineTextList.join('\n');
  }

  Future<String> _buildBrojClanovaText() async {
    List<String> terminiClanoviTextList = [];

    for (var terminId in _terminiIds) {
      Termini fetchedTermin = await fetchTermin(terminId);

      String termText =
          "${fetchedTermin.dan} (${fetchedTermin.sat}) - ${fetchedTermin.brojClanova}";

      terminiClanoviTextList.add(termText);
    }
    return terminiClanoviTextList.join('\n');
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

  int calculateAmount() {
    return iznos = (uracunajAkciju().toInt() * 100);
  }

  Future<Map<String, dynamic>> makePaymentIntent() async {
    String secretKey =
        const String.fromEnvironment("STRIPE_SECRET_KEY", defaultValue: "sk_test_51PnjR5Rum3JuFfOB3Viuai90sm9cG2Phf41MneR5nZ66M7cEjZg3kHw3mqUFt6dYfhlKOKjy2aAmhSO4XlETc5su00F1IKf7m6");

    final body = {
      'amount': calculateAmount().toString(),
      'currency': 'BAM',
      'payment_method_types[]': 'card',
    };

    final headers = {
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: headers,
      body: body,
    );

    return jsonDecode(response.body);
  }

  Future<void> displayPaymentSheet() async {
    try {
      await sp.Stripe.instance.presentPaymentSheet();
      await saveData();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        padding: const EdgeInsets.all(15),
        content: const Text(
          "Transakcija otkazana",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await makePaymentIntent();
      await sp.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: sp.SetupPaymentSheetParameters(
          merchantDisplayName: 'Kreiranje rezervacije',
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      throw Exception(e);
    }
  }

  void _prikaziOdabrano() {
    String? _selectedPaymentMethod = 'uCentru';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<String>(
          future: _buildTermineText(),
          builder:
              (BuildContext context, AsyncSnapshot<String> termineSnapshot) {
            return FutureBuilder<String>(
              future: _buildBrojClanovaText(),
              builder: (BuildContext context,
                  AsyncSnapshot<String> brojClanovaSnapshot) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 238, 247, 255),
                  title: const Text(
                    "Odabrali ste",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  content: termineSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          brojClanovaSnapshot.connectionState ==
                              ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Članarina: ${_clanarina.naziv}",
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    "Trening: ${_trening.naziv}",
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    "Učestalost: ${_terminiIds.length}x",
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Termini:",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    termineSnapshot.data ?? '',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Broj ljudi na odabranim terminima:",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    brojClanovaSnapshot.data ?? '',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 10),
                                  _treninziClanarineList.isNotEmpty
                                      ? Text(
                                          "Ukupno za platiti: ${uracunajAkciju()}KM",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(''),
                                  const SizedBox(height: 10),
                                  const Text("Odaberite način plaćanja:",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  Column(
                                    children: [
                                      ListTile(
                                        title: const Text('Plaćanje u centru'),
                                        leading: Radio<String>(
                                          value: 'uCentru',
                                          groupValue: _selectedPaymentMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedPaymentMethod = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Plaćanje online'),
                                        leading: Radio<String>(
                                          value: 'online',
                                          groupValue: _selectedPaymentMethod,
                                          onChanged: (String? value) async {
                                            setState(() {
                                              _selectedPaymentMethod = value;
                                            });
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await makePayment();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  if (_selectedPaymentMethod == 'uCentru')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Da li želite potvrditi rezervaciju?",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                saveData();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.green),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                              ),
                                              child: const Text("DA"),
                                            ),
                                            const SizedBox(width: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                _terminiIds.clear();
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                              ),
                                              child: const Text("NE"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  bool provjeriClanarinu() {
    return (_selectedClanarina == 3 && _terminiIds.length == 1) ||
        ((_selectedClanarina == 1 || _selectedClanarina == 2) &&
            _terminiIds.length > 1);
  }

  double uracunajAkciju() {
    double iznos = _treninziClanarineList[0].cijena!.toDouble();
    double discountPercentage = 0;
    for (Akcije akcija in _akcijeList) {
      discountPercentage = akcija.iznos.toDouble();
      iznos -= iznos * (discountPercentage / 100);
    }
    return double.parse(iznos.toStringAsFixed(2));
  }

  saveData() async {
    int korisnikId = korisnik.korisnikId;
    int clanarinaId = _selectedClanarina ?? 0;
    List<int> terminIds = _terminiIds;
    DateTime now = DateTime.now();
    DateTime datumIsteka;

    if (_selectedClanarina == 1) {
      // Mjesečna članarina
      datumIsteka = now.add(const Duration(days: 30));
    } else if (_selectedClanarina == 2) {
      // Sedmična članarina
      datumIsteka = now.add(const Duration(days: 7));
    } else if (_selectedClanarina == 3) {
      // Dnevna članarina
      datumIsteka = now.add(const Duration(hours: 24));
    } else {
      datumIsteka = now;
    }

    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now.toUtc());
    String formattedDatumIsteka =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(datumIsteka.toUtc());

    List<RezervacijeItem> items = terminIds
        .map((terminId) => RezervacijeItem(terminId: terminId))
        .toList();

    if (_selectedClanarina != null &&
        _selectedClanarina != 0 &&
        _selectedTrening != null) {
      if (_treninziClanarineList.isEmpty) {
        _showAlertDialog(
          "Greška",
          'Za odabranu članarinu "Dnevna" morate uzeti samo jedan termin, a za preostale članarine 2-5 termina.',
          Colors.red,
        );
        return;
      }

      DateTime convertToDateTime(String dan, String? sat) {
        Map<String, int> daysOfWeek = {
          'Ponedjeljak': DateTime.monday,
          'Utorak': DateTime.tuesday,
          'Srijeda': DateTime.wednesday,
          'Četvrtak': DateTime.thursday,
          'Petak': DateTime.friday,
          'Subota': DateTime.saturday,
          'Nedjelja': DateTime.sunday,
        };

        DateTime now = DateTime.now();
        int dayOfWeek = daysOfWeek[dan] ?? DateTime.monday;

        DateTime date =
            now.add(Duration(days: (dayOfWeek - now.weekday + 7) % 7));
        if (sat != null) {
          String cleanedSat = sat.replaceAll(RegExp(r'[^\d:]'), '');

          List<String> timeParts = cleanedSat.split(':');

          if (timeParts.length == 2) {
            try {
              int hour = int.parse(timeParts[0]);
              int minute = int.parse(timeParts[1]);

              date = DateTime(date.year, date.month, date.day, hour, minute);
            } catch (e) {
              print('Greška pri parsiranju vremena: $e');
            }
          }
        }

        return date;
      }

      if (_selectedClanarina == 3) {
        DateTime tomorrow = now.add(const Duration(days: 1));

        List<Future<Termini>> terminFutures =
            terminIds.map((terminId) => fetchTermin(terminId)).toList();
        List<Termini> termini = await Future.wait(terminFutures);

        bool allTerminiAreTomorrow = termini.every((termin) {
          DateTime terminDate = convertToDateTime(termin.dan, termin.sat);
          return terminDate.year == tomorrow.year &&
              terminDate.month == tomorrow.month &&
              terminDate.day == tomorrow.day;
        });

        if (!allTerminiAreTomorrow) {
          _showAlertDialog(
            "Greška",
            'Za dnevnu članarinu možete odabrati samo termine koji su zakazani za sutra.',
            Colors.red,
          );
          return;
        }

        if (terminIds.length > 1) {
          _showAlertDialog(
            "Greška",
            'Za dnevnu članarinu možete odabrati samo jedan termin.',
            Colors.red,
          );
          return;
        }
      } else if (_selectedClanarina == 2) {
        DateTime sevenDaysFromNow = now.add(const Duration(days: 7));

        List<Future<Termini>> terminFutures =
            terminIds.map((terminId) => fetchTermin(terminId)).toList();
        List<Termini> termini = await Future.wait(terminFutures);

        bool allTerminiAreWithinSevenDays = termini.every((termin) {
          DateTime terminDate = convertToDateTime(termin.dan, termin.sat);
          return terminDate.isAfter(now) &&
              terminDate.isBefore(sevenDaysFromNow);
        });

        if (!allTerminiAreWithinSevenDays) {
          _showAlertDialog(
            "Greška",
            'Za sedmičnu članarinu možete odabrati samo termine unutar narednih 7 dana.',
            Colors.red,
          );
          return;
        }
      } else if (_selectedClanarina == 1) {
        DateTime thirtyDaysFromNow = now.add(const Duration(days: 30));

        List<Future<Termini>> terminFutures =
            terminIds.map((terminId) => fetchTermin(terminId)).toList();
        List<Termini> termini = await Future.wait(terminFutures);

        bool allTerminiAreWithinThirtyDays = termini.every((termin) {
          DateTime terminDate = convertToDateTime(termin.dan, termin.sat);
          return terminDate.isAfter(now) &&
              terminDate.isBefore(thirtyDaysFromNow);
        });

        if (!allTerminiAreWithinThirtyDays) {
          _showAlertDialog(
            "Greška",
            'Za mjesečnu članarinu možete odabrati samo termine unutar narednih 30 dana.',
            Colors.red,
          );
          return;
        }
      }

      double finalnaCijena = uracunajAkciju();

      RezervacijeRequest request = RezervacijeRequest(
          datum: formattedDate,
          korisnikId: korisnikId,
          clanarinaId: clanarinaId,
          iznos: finalnaCijena,
          items: items,
          datumIsteka: formattedDatumIsteka,
          brojTransakcije: paymentIntent?['id']);

      if (_rezervacijeCount1! < 3 &&
          _rezervacijeCount2! == 0 &&
          provjeriClanarinu()) {
        await _rezervacijeProvider.insert(request.toJson());
        if (paymentIntent != null) {
          _showAlertDialog(
            "Rezervisano!",
            "Uspješno obavljena transakcija i kreirana rezervacija.",
            Colors.green,
          );
        } else {
          _showAlertDialog(
            "Rezervisano!",
            "Uspješno kreirana rezervacija.",
            Colors.green,
          );
        }
        setState(() {
          _selectedTermini.clear();
          _terminiIds.clear();
          _terminiList.clear();
          _terminiIds = [];
          _selectedClanarina = null;
          _selectedVrstaTreninga = null;
          _selectedTrening = null;
          paymentIntent = null;
        });
      } else if (_rezervacijeCount2! != 0) {
        _showAlertDialog(
            "Greška",
            "Prethodno ste rezervisali odabrani trening. Nije moguće rezervisati isti trening u sklopu više rezervacija.",
            Colors.red);
      } else if (_rezervacijeCount1! != 0) {
        _showAlertDialog(
          "Greška",
          "Napravili ste maksimalan broj rezervacija. Otkažite neku od njih ili sačekajte da istekne neka od prethodno rezervisanih.",
          Colors.red,
        );
      }
    } else {
      _showAlertDialog(
        "Greška",
        "Morate odabrati članarinu i neki od treninga.",
        Colors.red,
      );
    }
  }
}
