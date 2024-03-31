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
  TextEditingController _nazivController = new TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _akcijeProvider = context.read<AkcijeProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
  }

  void _loadData() async {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _searchWidgets()),
          SizedBox(height: 10),
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
      title: "Akcije",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddActionDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  String formatDate(DateTime? dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime!);
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
                  borderSide: BorderSide(
                    color: const Color.fromRGBO(0, 154, 231, 1),
                  ),
                ),
              ),
              controller: _nazivController,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: FormBuilderDateTimePicker(
                  name: 'datumPocetka',
                  inputType: InputType.date,
                  decoration: const InputDecoration(labelText: 'Datum početka'),
                  format: DateFormat("yyyy-MM-dd"),
                  initialDate: _selectedDate ?? DateTime.now(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDate = value;
                    });
                  }),
            ),
          ),
          SizedBox(width: 10),
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
                child: Text("Pretraži"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(0, 154, 231, 1),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                  side: BorderSide(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listOfActiveActions() {
    ScrollController _scrollController = ScrollController();

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
                          ? Color.fromARGB(255, 46, 142, 50)
                          : Colors.grey),
                ),
              ),
              SizedBox(width: 10),
              Text('/'),
              SizedBox(width: 10),
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
          SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: _selectedAkcije.map((akcija) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 225, 225, 225),
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
    ScrollController _scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Arhiva',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 94, 94)),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: _arhiviraneAkcijeList.map((akcija) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 225, 225, 225),
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
                      decoration: const InputDecoration(labelText: 'Naziv'),
                      onChanged: (value) {
                        setState(() {
                          acTrening.naziv = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                          return 'Naziv mora početi velikim slovom.';
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
                        print('Input value: $value');
                        if (value != null && value.isNotEmpty) {
                          setState(() {
                            try {
                              acTrening.iznos = int.parse(value);
                            } catch (e) {
                              print('Error parsing integer: $e');
                            }
                          });
                        } else {
                          print('Input value is empty or null');
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (value != null &&
                            !RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Ovo polje može sadržavati samo brojeve.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDateTimePicker(
                      name: 'datumPocetka',
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                          labelText: 'Datum početka akcije'),
                      format: DateFormat("yyyy-MM-dd"),
                      initialDate: _pocetakAkcije ?? DateTime.now(),
                      onChanged: (value) {
                        setState(() {
                          acTrening.datumPocetka = value ?? DateTime.now();
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          if (value == null) {
                            return 'Ovo polje je obavezno!';
                          }
                          return null;
                        },
                      ]),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'datumZavrsetka',
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                          labelText: 'Datum završetka akcije'),
                      format: DateFormat("yyyy-MM-dd"),
                      initialDate: _zavrsetakAkcije ?? DateTime.now(),
                      onChanged: (value) {
                        setState(() {
                          acTrening.datumZavrsetka = value ?? DateTime.now();
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          if (value == null) {
                            return 'Ovo polje je obavezno!';
                          }
                          return null;
                        },
                      ]),
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'items',
                      decoration: const InputDecoration(labelText: 'Treninzi'),
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
              child: const Text('Odustani'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> items = [];

                _acTreningProvider.acTrening.items.forEach((item) {
                  items.add(
                    {"treningId": item.trening.treningId},
                  );
                  print("Dodani " + item.trening.naziv);
                });

                Map<String, dynamic> action = {
                  "items": items,
                  'naziv': acTrening.naziv,
                  'datumPocetka': formatDateForJson(acTrening.datumPocetka),
                  'datumZavrsetka': formatDateForJson(acTrening.datumZavrsetka),
                  'iznos': acTrening.iznos
                };

                _formKey.currentState?.saveAndValidate();
                final currentFormState = _formKey.currentState;
                if (!_areAllFieldsFilled(currentFormState)) {
                  _showAlertDialog("Upozorenje", "Popunite sva obavezna polja.",
                      Colors.orange);
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

                try {
                  var response = await _akcijeProvider.insert(action);
                  setState(() {});
                  _showAlertDialog(
                      "Uspješan unos", "Akcija uspješno dodana.", Colors.green);
                } on Exception catch (e) {
                  _showAlertDialog("Greška", e.toString(), Colors.red);
                }
              },
              child: const Text('Spremi'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0, 154, 231, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = [
      'naziv',
      'iznos',
      'datumPocetka',
      'datumZavrsetka'
    ];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
  }

  String formatDateForJson(DateTime dateTime) {
    return dateTime.toIso8601String();
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
