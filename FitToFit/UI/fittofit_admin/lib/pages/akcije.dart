import 'package:fittofit_admin/models/acTrening.dart';
import 'package:fittofit_admin/models/akcije.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/providers/acTrening_provider.dart';
import 'package:fittofit_admin/providers/akcije_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/widgets/action_card.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AkcijePage extends StatefulWidget {
  const AkcijePage({Key? key}) : super(key: key);

  @override
  State<AkcijePage> createState() => _AkcijePageState();
}

class _AkcijePageState extends State<AkcijePage> {
  late AkcijeProvider _akcijeProvider;
  late TreninziProvider _treninziProvider;
  late AcTreningProvider _acTreningProvider = AcTreningProvider();
  final TextEditingController _nazivController = TextEditingController();
  List<Akcije> _aktivneAkcijeList = [];
  List<Akcije> _arhiviraneAkcijeList = [];
  List<Akcije> _draftAkcijeList = [];
  List<Akcije> _selectedAkcije = [];
  List<Treninzi> _treninziList = [];
  DateTime? _selectedDate;
  DateTime? _pocetakAkcije;
  DateTime? _zavrsetakAkcije;
  List<String> nazivList = [];
  Treninzi? _selectedTraining;
  late AcTrening acTrening;
  List<int>? items;
  bool isActive = true;
  final _formKey = GlobalKey<FormBuilderState>();
  FocusNode _nazivFocusNode = FocusNode();
  String? _dateErrorMessage1;
  String? _dateErrorMessage2;

  @override
  void initState() {
    super.initState();
    _akcijeProvider = context.read<AkcijeProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
    _akcijeProvider.addListener(() {
      _reloadAkcijeList();
    });
    _nazivFocusNode = FocusNode();
    _dateErrorMessage1 = "Datum početka akcije je obavezan.";
    _dateErrorMessage2 = "Datum završetka akcije je obavezan.";
  }

  void _reloadAkcijeList() async {
    var aktivneAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "active"});

    var arhiviraneAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "archived"});

    var draftAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "draft"});
    if (mounted) {
      setState(() {
        _aktivneAkcijeList = aktivneAkcije.result;
        _arhiviraneAkcijeList = arhiviraneAkcije.result;
        _draftAkcijeList = draftAkcije.result;
        _selectedAkcije = _aktivneAkcijeList;
        isActive = true;
      });
    }
  }

  @override
  void dispose() {
    _nazivFocusNode.dispose();
    super.dispose();
  }

  void _loadData() async {
    if (!mounted) return;
    var aktivneAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "active"});

    var arhiviraneAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "archived"});

    var draftAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "draft"});

    var treninzi = await _treninziProvider.get();

    setState(() {
      _aktivneAkcijeList = aktivneAkcije.result;
      _arhiviraneAkcijeList = arhiviraneAkcije.result;
      _draftAkcijeList = draftAkcije.result;
      _treninziList = treninzi.result;
      _selectedAkcije = _aktivneAkcijeList;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _acTreningProvider = context.watch<AcTreningProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Akcije",
      selectedIndex: 3,
      showBackArrow: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddActionDialog();
        },
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _searchWidgets()),
          const SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: _listOfActiveActions(),
          ),
          Expanded(
            flex: 4,
            child: _listOfArchivedActions(),
          ),
        ],
      ),
    );
  }

  Widget _searchWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Naziv akcije",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 154, 231, 1),
                  ),
                ),
              ),
              controller: _nazivController,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: FormBuilderDateTimePicker(
                      name: 'datumPocetka',
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Datum početka',
                        suffixIcon: _selectedDate != null
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.red),
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
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 130),
              child: ElevatedButton(
                onPressed: () async {
                  var data1 = await _akcijeProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'datumPocetka': _selectedDate,
                    'stateMachine': "active"
                  });

                  var data2 = await _akcijeProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'datumPocetka': _selectedDate,
                    'stateMachine': "archived"
                  });

                  var data3 = await _akcijeProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'datumPocetka': _selectedDate,
                    'stateMachine': "draft"
                  });

                  setState(() {
                    _aktivneAkcijeList = data1.result;
                    _arhiviraneAkcijeList = data2.result;
                    _draftAkcijeList = data3.result;
                    if (isActive) {
                      _selectedAkcije = _aktivneAkcijeList;
                    } else {
                      _selectedAkcije = _draftAkcijeList;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text("Pretraži"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listOfActiveActions() {
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
                    _selectedAkcije = _aktivneAkcijeList;
                  });
                },
                child: Text(
                  'Aktivne akcije',
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
                    _selectedAkcije = _draftAkcijeList;
                  });
                },
                child: Text(
                  'Draft akcije',
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
                  children: _selectedAkcije.map((akcija) {
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AkcijeCard(akcija: akcija),
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

  Widget _listOfArchivedActions() {
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
                children: _arhiviraneAkcijeList.map((akcija) {
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
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AkcijeCard(akcija: akcija)),
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

  void _showAddActionDialog() {
    acTrening = AcTrening();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_nazivFocusNode);
        });
        return AlertDialog(
          title: const Text('Dodaj akciju'),
          content: Container(
            width: 400.0,
            height: 600.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'naziv',
                      focusNode: _nazivFocusNode,
                      decoration: const InputDecoration(labelText: 'Naziv'),
                      onChanged: (value) {
                        setState(() {
                          acTrening.naziv = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (!RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                          return 'Naziv mora početi velikim slovom.';
                        } else if (value.length < 5) {
                          return 'Morate unijeti najmanje 5 karaktera.';
                        } else if (value.length > 50) {
                          return 'Premašili ste maksimalan broj karaktera (50).';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'iznos',
                      decoration: const InputDecoration(labelText: 'Iznos (%)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty) {
                          setState(() {
                            try {
                              acTrening.iznos = int.parse(value);
                            } catch (e) {
                              print('Error parsing integer: $e');
                            }
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Ovo polje može sadržavati samo brojeve.';
                        } else {
                          final broj = int.tryParse(value) ?? 0;
                          if (broj < 1 || broj > 99) {
                            return 'Dozvoljen je unos brojeva između 1 i 99.';
                          }
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
                          lastDate: DateTime.utc(2024, 12, 31),
                        );
                        if (date == null) {
                          setState(() {
                            _pocetakAkcije = null;
                            _dateErrorMessage1 =
                                "Datum početka akcije je obavezan.";
                          });
                        } else {
                          setState(() {
                            _pocetakAkcije = date;
                            _dateErrorMessage1 = null;
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
                            "Izaberite datum početka akcije",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    if (_dateErrorMessage1 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _dateErrorMessage1!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    _pocetakAkcije != null
                        ? Text(
                            "Izabrani datum početka: ${_pocetakAkcije?.day}.${_pocetakAkcije?.month}.${_pocetakAkcije?.year}.",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(),
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
                          lastDate: DateTime.utc(2024, 12, 31),
                        );
                        if (date == null) {
                          setState(() {
                            _zavrsetakAkcije = null;
                            _dateErrorMessage2 =
                                "Datum završetka akcije je obavezan.";
                          });
                        } else {
                          setState(() {
                            _zavrsetakAkcije = date;
                            _dateErrorMessage2 = null;
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
                            "Izaberite datum završetka akcije",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    if (_dateErrorMessage2 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _dateErrorMessage2!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    _zavrsetakAkcije != null
                        ? Text(
                            "Izabrani datum završetka: ${_zavrsetakAkcije?.day}.${_zavrsetakAkcije?.month}.${_zavrsetakAkcije?.year}.",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'items',
                      decoration: const InputDecoration(labelText: 'Trening'),
                      initialValue: _selectedTraining,
                      items: _treninziList.map((trening) {
                        return DropdownMenuItem(
                          value: trening,
                          child: Text(trening.naziv),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTraining = newValue as Treninzi;
                        });

                        if (_selectedTraining != null) {
                          _acTreningProvider
                              .addToAc(_selectedTraining as Treninzi);
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Ovo polje je obavezno!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0)
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
              onPressed: () async {
                late String datumVrijemeP;
                late String datumVrijemeZ;

                if (_pocetakAkcije == null) {
                  setState(() {
                    _dateErrorMessage1 = "Datum početka akcije je obavezan.";
                  });
                  return;
                }
                if (_zavrsetakAkcije == null) {
                  setState(() {
                    _dateErrorMessage2 = "Datum završetka akcije je obavezan.";
                  });
                  return;
                }

                if (_pocetakAkcije!.isAfter(_zavrsetakAkcije!)) {
                  setState(() {
                    _dateErrorMessage1 =
                        "Datum početka akcije ne može biti poslije datuma završetka akcije.";
                    _dateErrorMessage2 =
                        "Datum početka akcije ne može biti poslije datuma završetka akcije.";
                  });
                  return;
                }

                _formKey.currentState?.saveAndValidate();
                if (_formKey.currentState!.validate()) {
                  String datumPocetka = _pocetakAkcije.toString();
                  datumVrijemeP =
                      DateTime.parse(datumPocetka.replaceAll(' ', 'T'))
                          .toIso8601String();
                  String datumZavrsetka = _zavrsetakAkcije.toString();
                  datumVrijemeZ =
                      DateTime.parse(datumZavrsetka.replaceAll(' ', 'T'))
                          .toIso8601String();
                  List<Map<String, dynamic>> items = [];

                  for (var item in _acTreningProvider.acTrening.items) {
                    items.add(
                      {"treningId": item.trening.treningId},
                    );
                  }

                  Map<String, dynamic> action = {
                    "items": items,
                    'naziv': acTrening.naziv,
                    'datumPocetka': datumVrijemeP,
                    'datumZavrsetka': datumVrijemeZ,
                    'iznos': acTrening.iznos
                  };

                  try {
                    await _akcijeProvider.insert(action);
                    setState(() {
                      _formKey.currentState?.reset();
                      _pocetakAkcije = null;
                      _zavrsetakAkcije = null;
                      _selectedTraining = null;
                      _dateErrorMessage1 = "Datum početka akcije je obavezan.";
                      _dateErrorMessage2 =
                          "Datum završetka akcije je obavezan.";
                      _treninziList = [];
                      _loadData();
                    });
                    _showAlertDialog("Uspješan unos", "Akcija uspješno dodana.",
                        Colors.green);
                  } on Exception catch (e) {
                    _showAlertDialog("Greška", e.toString(), Colors.red);
                  }
                }
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
