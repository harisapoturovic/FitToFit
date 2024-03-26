import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:fittofit_admin/widgets/tranining_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class TreninziPage extends StatefulWidget {
  const TreninziPage({Key? key}) : super(key: key);

  @override
  State<TreninziPage> createState() => _TreninziPageState();
}

class _TreninziPageState extends State<TreninziPage> {
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreninziProvider _treninziProvider;
  TextEditingController _nazivController = new TextEditingController();
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  String? _selectedType;
  final _formKey = GlobalKey<FormBuilderState>();
  File? _image;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
  }

  void _loadData() async {
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
    var treninzi = await _treninziProvider.get(filter: {});
    setState(() {
      _vrsteTreningaList = vrsteTreninga.result;
      _treninziList = treninzi.result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          Container(child: _searchWidgets()),
          SizedBox(height: 10),
          Expanded(
            child: _listOfTrainings(),
          ),
        ],
      ),
      title: "Treninzi",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTrainingsDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  Widget _searchWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 500.0, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Naziv treninga"),
                  controller: _nazivController,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await _treninziProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'vrstaTreninga': _selectedType
                  });

                  setState(() {
                    _treninziList = data.result;
                  });
                },
                child: Text("Pretraži"),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 520.0),
          child: Row(
            children: _vrsteTreningaList.map((vrsta) {
              bool isSelected = vrsta.naziv == _selectedType;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = isSelected ? null : vrsta.naziv;
                    });
                  },
                  style: ButtonStyle(
                    textStyle:
                        MaterialStateProperty.resolveWith<TextStyle>((states) {
                      if (isSelected) {
                        return TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                        );
                      } else {
                        return TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        );
                      }
                    }),
                  ),
                  child: Text(vrsta.naziv!),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _listOfTrainings() {
    ScrollController _scrollController = ScrollController();

    return Container(
      margin: EdgeInsets.only(bottom: 80, left: 50, right: 50, top: 100),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 245, 248),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            children: _treninziList.map((training) {
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
                    child: TrainingCard(training: training),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showAddTrainingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj trening'),
          content: Container(
            width: 500.0,
            height: 900.0,
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
                      name: 'opis',
                      decoration: const InputDecoration(labelText: 'Opis'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                          return 'Opis mora početi velikim slovom.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'maxBrojClanova',
                      decoration: const InputDecoration(
                          labelText: 'Maksimalan broj članova'),
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
                    FormBuilderTextField(
                      name: 'cijenaPoTerminu',
                      decoration:
                          const InputDecoration(labelText: 'Cijena po terminu (KM)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (value != null &&
                            !RegExp(r'^[0-9]+(?:[.,][0-9]+)*$').hasMatch(value)) {
                          return 'Ovo polje ne može sadržavati slova.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'trajanje',
                      decoration: const InputDecoration(labelText: 'Trajanje (min/h)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'prosjecnaPotrosnjaKalorija',
                      decoration: const InputDecoration(
                          labelText: 'Prosječna potrošnja kalorija (kcal)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (value != null &&
                            !RegExp(r'^[0-9]+(?:[.,][0-9]+)*$').hasMatch(value)) {
                          return 'Ovo polje ne može sadržavati slova.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'namjena',
                      decoration: const InputDecoration(labelText: 'Namjena'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                          return 'Namjena mora početi velikim slovom.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'vrstaId',
                      decoration:
                          const InputDecoration(labelText: 'Vrsta treninga'),
                      initialValue: _vrsteTreningaList[0].vrstaTreningaId,
                      items: _vrsteTreningaList.map((vrstaTreninga) {
                        return DropdownMenuItem(
                          value: vrstaTreninga.vrstaTreningaId,
                          child: Text(vrstaTreninga.naziv!),
                        );
                      }).toList(),
                    ),
                    FormBuilderField(
                      name: 'slika',
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Odaberite sliku',
                            errorText: field.errorText,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text("Select image"),
                            trailing: const Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
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
              child: const Text('Odustani'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _dodajTrening();
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

  void _dodajTrening() {
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
    request['slika'] = _base64Image;
    try {
      _treninziProvider.insert(request);
      _showAlertDialog(
          "Uspješan unos", "Trening uspješno dodat.", Colors.green);
    } on Exception catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = [
      'naziv',
      'opis',
      'maxBrojClanova',
      'cijenaPoTerminu',
      'trajanje',
      'prosjecnaPotrosnjaKalorija',
      'vrstaId',
      'namjena'
    ];

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
