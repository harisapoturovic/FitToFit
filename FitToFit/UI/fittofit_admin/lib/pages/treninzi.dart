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
  final TextEditingController _nazivController = TextEditingController();
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  String? _selectedType;
  final _formKey = GlobalKey<FormBuilderState>();
  File? _image;
  String? _base64Image;
  FocusNode _nazivFocusNode = FocusNode();
  int? selectedVrstaTreninga;
  String? selectedNamjena;

  List<String> namjena = [];

  @override
  void initState() {
    super.initState();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
    _treninziProvider.addListener(() {
      _reloadTreninziList();
    });
    _nazivFocusNode = FocusNode();
  }

  void _reloadTreninziList() async {
    var treninzi = await _treninziProvider.get(filter: {});
    if (mounted) {
      setState(() {
        _treninziList = treninzi.result;
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
    var vrsteTreninga =
        await _vrsteTreningaProvider.get(filter: {'IsTerminiIncluded': true});
    var treninzi = await _treninziProvider.get(filter: {});
    namjena = [
      'Mršavljenje',
      'Izgradnja mišića',
      'Kondicija',
      'Fleksibilnost i mobilnost',
      'Rehabilitacija i oporavak'
    ];
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
      title: "Treninzi",
      selectedIndex: 2,
      showBackArrow: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTrainingsDialog();
        },
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      child: Column(
        children: [
          Container(child: _searchWidgets()),
          const SizedBox(height: 10),
          Expanded(
            child: _listOfTrainings(),
          ),
        ],
      ),
    );
  }

  Widget _searchWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 500.0, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: "Naziv treninga"),
                  controller: _nazivController,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await _treninziProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'vrstaTreningaNaziv': _selectedType
                  });

                  setState(() {
                    _treninziList = data.result;
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
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 520.0),
          child: Row(
            children: _vrsteTreningaList.map((vrsta) {
              bool isSelected = vrsta.naziv == _selectedType;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        return const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                        );
                      } else {
                        return const TextStyle(
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
    ScrollController scrollController = ScrollController();

    return Container(
      margin: const EdgeInsets.only(bottom: 80, left: 50, right: 50, top: 100),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 245, 248),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scrollbar(
          controller: scrollController,
          child: ListView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            children: _treninziList.map((training) {
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_nazivFocusNode);
        });
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
                      focusNode: _nazivFocusNode,
                      decoration: const InputDecoration(labelText: 'Naziv'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (!RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                          return 'Naziv mora početi velikim slovom.';
                        } else if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ\s]+$')
                            .hasMatch(value)) {
                          return 'Naziv može sadržavati samo slova.';
                        } else if (value.length < 3) {
                          return 'Morate unijeti najmanje 3 karaktera.';
                        } else if (value.length > 50) {
                          return 'Premašili ste maksimalan broj karaktera (50).';
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
                        } else if (!RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                          return 'Opis mora početi velikim slovom.';
                        } else if (value.length < 5) {
                          return 'Morate unijeti najmanje 5 karaktera.';
                        } else if (value.length > 600) {
                          return 'Premašili ste maksimalan broj karaktera.';
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
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Ovo polje može sadržavati samo brojeve.';
                        } else {
                          final broj = int.tryParse(value) ?? 0;
                          if (broj < 1 || broj > 20) {
                            return 'Dozvoljen je unos brojeva između 1 i 20.';
                          }
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'cijenaPoTerminu',
                      decoration: const InputDecoration(
                          labelText: 'Cijena po terminu (KM)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (!RegExp(r'^\d+([.,]\d+)?$')
                            .hasMatch(value)) {
                          return 'Ovo polje može sadržavati cijele i decimalne brojeve s tačkom ili zarezom.';
                        } else {
                          final broj =
                              double.tryParse(value.replaceAll(',', '.')) ?? 0;
                          if (broj < 1 || broj > 10) {
                            return 'Dozvoljen je unos brojeva između 1 i 10.';
                          }
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'trajanje',
                      decoration:
                          const InputDecoration(labelText: 'Trajanje (min)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Ovo polje može sadržavati samo brojeve.';
                        } else {
                          final broj = int.tryParse(value) ?? 0;
                          if (broj < 20 || broj > 90) {
                            return 'Dozvoljen je unos brojeva između 20 i 90.';
                          }
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
                        } else if (!RegExp(r'^\d+([.,]\d+)?$')
                            .hasMatch(value)) {
                          return 'Ovo polje može sadržavati cijele i decimalne brojeve s tačkom ili zarezom.';
                        } else {
                          final broj =
                              double.tryParse(value.replaceAll(',', '.')) ?? 0;
                          if (broj < 100 || broj > 1500) {
                            return 'Dozvoljen je unos brojeva između 100 i 1500.';
                          }
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'namjena',
                      decoration: const InputDecoration(labelText: 'Namjena'),
                      initialValue: selectedNamjena,
                      items: namjena.map((n) {
                        return DropdownMenuItem(
                          value: n,
                          child: Text(n),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedNamjena = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Ovo polje je obavezno!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'vrstaId',
                      decoration:
                          const InputDecoration(labelText: 'Vrsta treninga'),
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
                      validator: (value) {
                        if (value == null) {
                          return 'Ovo polje je obavezno!';
                        }
                        return null;
                      },
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
                            title: const Text("Odaberite sliku"),
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
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _dodajTrening();
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

  void _dodajTrening() {
    _formKey.currentState?.saveAndValidate();
    if (_formKey.currentState!.validate()) {
      var request = Map.from(_formKey.currentState!.value);
      request['cijenaPoTerminu'] =
          request['cijenaPoTerminu'].replaceAll(',', '.');
      request['prosjecnaPotrosnjaKalorija'] =
          request['prosjecnaPotrosnjaKalorija'].replaceAll(',', '.');

      request['slika'] = _base64Image;
      try {
        _treninziProvider.insert(request);
        if (mounted) {
          setState(() {
            _formKey.currentState?.reset();
            selectedVrstaTreninga = null;
            selectedNamjena = null;
            namjena = [];
            _vrsteTreningaList = [];
            _image = null;
            _base64Image = null;
            _loadData();
          });
        }
        _showAlertDialog(
            "Uspješan unos", "Trening uspješno dodat.", Colors.green);
      } on Exception catch (e) {
        _showAlertDialog("Greška", e.toString(), Colors.red);
      }
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
            onPressed: () {
              Navigator.of(context).pop();
            },
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
