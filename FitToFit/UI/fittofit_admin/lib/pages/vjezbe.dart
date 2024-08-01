import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/models/acTrening.dart';
import 'package:fittofit_admin/models/vjezbe.dart';
import 'package:fittofit_admin/providers/vjezbe_provider.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:fittofit_admin/widgets/vjezba_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class VjezbePage extends StatefulWidget {
  const VjezbePage({Key? key}) : super(key: key);

  @override
  State<VjezbePage> createState() => _VjezbePageState();
}

class _VjezbePageState extends State<VjezbePage> {
  late VjezbeProvider _vjezbeProvider;
  final TextEditingController _nazivController = TextEditingController();
  List<Vjezbe> _vjezbeList = [];
  List<String> nazivList = [];
  late AcTrening acTrening;
  List<int>? items;
  bool isActive = true;
  File? _image;
  String? _base64Image;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _vjezbeProvider = context.read<VjezbeProvider>();
    _loadData();
  }

  void _loadData() async {
    var vjezbe = await _vjezbeProvider.get();
    setState(() {
      _vjezbeList = vjezbe.result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Vježbe",
      selectedIndex: 6,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVjezbuDialog();
        },
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
        child: const Icon(Icons.add),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _searchWidgets()),
          const SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: _listOfExercises(),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget _searchWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Naziv vježbe",
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
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 130),
              child: ElevatedButton(
                onPressed: () async {
                  var data = await _vjezbeProvider
                      .get(filter: {'naziv': _nazivController.text});

                  setState(() {
                    _vjezbeList = data.result;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(0, 154, 231, 1),
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

  Widget _listOfExercises() {
    ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: _vjezbeList.map((vjezba) {
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
                          child: VjezbaCard(vjezba: vjezba),
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

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }

  void _showAddVjezbuDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj vježbu'),
          content: Container(
            width: 400.0,
            height: 400.0,
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

                        if (value.length > 50) {
                          return 'Možete unijeti maksimalno 50 karaktera.';
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
                        if (value.length < 5) {
                          return 'Morate unijeti najmanje 5 karaktera.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
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
              onPressed: () {
                _dodajVjezbu();
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

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = ['naziv', 'opis'];

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

  void _dodajVjezbu() {
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
      _vjezbeProvider.insert(request);
      _showAlertDialog(
          "Uspješan unos", "Vježba uspješno dodana.", Colors.green);
    } on Exception catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }
}
