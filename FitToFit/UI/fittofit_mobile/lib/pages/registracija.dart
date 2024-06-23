import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegistracijaPage extends StatefulWidget {
  const RegistracijaPage({Key? key}) : super(key: key);

  @override
  State<RegistracijaPage> createState() => _RegistracijaPageState();
}

class _RegistracijaPageState extends State<RegistracijaPage> {
  final TextEditingController imeController = TextEditingController();
  final TextEditingController prezimeController = TextEditingController();
  final TextEditingController spolController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adresaController = TextEditingController();
  final TextEditingController datumRodjenjaController = TextEditingController();
  final TextEditingController korisnickoImeController = TextEditingController();
  final TextEditingController lozinkaController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = true;
  Korisnici? korisnik;
  late KorisniciProvider _korisniciProvider;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  File? _image;
  String? _base64Image;

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
      title: "Registracija",
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [isLoading ? Container() : _addForm()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addForm() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SizedBox(
                height: 550,
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "ime",
                        controller: imeController,
                        decoration: const InputDecoration(labelText: "Ime"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          }
                          if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                            return 'Ime mora početi velikim slovom.';
                          }

                          if (!RegExp(r'^[A-Za-z]*$').hasMatch(value)) {
                            return 'Ime može sadržavati samo slova.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "prezime",
                        controller: prezimeController,
                        decoration: const InputDecoration(labelText: "Prezime"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          }
                          if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                            return 'Prezime mora početi velikim slovom.';
                          }

                          if (!RegExp(r'^[A-Za-z]*$').hasMatch(value)) {
                            return 'Prezime može sadržavati samo slova.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderDropdown(
                        name: 'spol',
                        decoration: const InputDecoration(labelText: 'Spol'),
                        initialValue: 'Muški',
                        items: ['Muški', 'Ženski'].map((spol) {
                          return DropdownMenuItem(
                            value: spol,
                            child: Text(spol),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                          name: "telefon",
                          controller: telefonController,
                          decoration:
                              const InputDecoration(labelText: "Telefon"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno!';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Ovo polje može sadržavati samo brojeve.';
                            }
                            if (value.length > 10) {
                              return 'Broj telefona može imati maksimalno 10 cifara.';
                            }
                            return null;
                          }),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "email",
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "E-mail"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          }
                          if (value.isNotEmpty) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Unesite validnu e-mail adresu.';
                            }
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SizedBox(
                height: 550,
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'adresa',
                        decoration: const InputDecoration(labelText: 'Adresa'),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              !RegExp(r'^[A-Z]').hasMatch(value)) {
                            return 'Adresa mora početi velikim slovom.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderDateTimePicker(
                        name: 'datumRodjenja',
                        inputType: InputType.date,
                        decoration:
                            const InputDecoration(labelText: 'Datum rodjenja'),
                        format: DateFormat("yyyy-MM-dd"),
                        initialDate: _selectedDate ?? DateTime.now(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDate = value;
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
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                          name: "korisnickoIme",
                          controller: korisnickoImeController,
                          decoration: const InputDecoration(
                              labelText: "Korisničko ime"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno!';
                            }
                            return null;
                          }),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "password",
                        controller: lozinkaController,
                        decoration: const InputDecoration(labelText: "Lozinka"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          } else if (value.length < 8 ||
                              !value.contains(RegExp(r'[A-Z]')) ||
                              !value.contains(RegExp(r'[a-z]')) ||
                              !value.contains(RegExp(r'[0-9]'))) {
                            return '8 karaktera,uključujući najmanje jedno veliko slovo (A-Z), jedno malo slovo (a-z) i jednu cifru (0-9)';
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
                              title: const Text("Select image"),
                              trailing: const Icon(Icons.file_upload),
                              onTap: getImage,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _dodajAdmina();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(0, 154, 231, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        child: const Text('Spremi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = [
      'ime',
      'prezime',
      'korisnickoIme',
      'email',
      'password',
      'telefon',
      'spol',
      'datumRodjenja'
    ];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
  }

  void _dodajAdmina() {
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
    String formattedDate = request['datumRodjenja'].toIso8601String();
    request['datumRodjenja'] = formattedDate;
    request['slika'] = _base64Image;
    request['passwordPotvrda'] = request['password'];
    request['ulogaId'] = 2;

    try {
      _korisniciProvider.insert(request);
      _showAlertDialog("Uspješan unos", "Admin uspješno dodat.", Colors.green);
    } on Exception catch (e) {
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
}
