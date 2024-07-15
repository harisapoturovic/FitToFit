import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
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
  final TextEditingController korisnickoImeController = TextEditingController();
  final TextEditingController lozinkaController = TextEditingController();
  final TextEditingController visinaController = TextEditingController();
  final TextEditingController tezinaController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = true;
  Korisnici? korisnik;
  late KorisniciProvider _korisniciProvider;
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  bool usernameTaken = false;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));

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

  Future<void> initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  File? _image;
  String? _base64Image;

  Future<void> getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null && result.files.isNotEmpty) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(await _image!.readAsBytes());
      setState(() {});
    }
  }

  Future<void> provjeriUsername(String username) async {
    try {
      var temp = await _korisniciProvider
          .get(filter: {"korisnickoIme": username, "isAdmin": false});
      if (mounted) {
        setState(() {
          usernameTaken = temp.count > 0;
          if (usernameTaken) {
            _showAlertDialog("Greška",
                "Korisnik sa ovim username-om već postoji", Colors.red);
          }
        });
      }
    } catch (e) {
      print('Greška pri provjeri username-a: $e');
    }
  }

  Future<void> debouncedUsernameCheck(String username) async {
    // Pokreće debouncing
    debouncer.run(() async {
      await provjeriUsername(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Registracija'),
            backgroundColor: Colors.deepPurple.shade300),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isLoading ? Container() : _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                decoration: const InputDecoration(labelText: "Telefon"),
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
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Unesite validnu e-mail adresu.';
                    }
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            FormBuilderTextField(
              name: 'adresa',
              controller: adresaController,
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
              decoration: const InputDecoration(labelText: 'Datum rođenja'),
              format: DateFormat("yyyy-MM-dd"),
              initialDate: _selectedDate1 ?? DateTime.now(),
              onChanged: (value) {
                setState(() {
                  _selectedDate1 = value;
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
            FormBuilderDateTimePicker(
              name: 'datumPocetkaTreniranja',
              inputType: InputType.date,
              decoration:
                  const InputDecoration(labelText: 'Datum početka treniranja'),
              format: DateFormat("yyyy-MM-dd"),
              initialDate: _selectedDate2 ?? DateTime.now(),
              onChanged: (value) {
                setState(() {
                  _selectedDate2 = value;
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
                name: "visina",
                controller: visinaController,
                decoration: const InputDecoration(labelText: "Visina"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno!';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            FormBuilderTextField(
                name: "tezina",
                controller: tezinaController,
                decoration: const InputDecoration(labelText: "Težina"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno!';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            FormBuilderTextField(
                name: "korisnickoIme",
                controller: korisnickoImeController,
                decoration: const InputDecoration(labelText: "Korisničko ime"),
                onChanged: (val) async {
                  if (val != null && val != '') {
                    debouncedUsernameCheck(val);
                  }
                },
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
            const SizedBox(height: 15),
            if (_image != null) Image.file(_image!),
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
                    title: const Text("Odaberi sliku"),
                    trailing: const Icon(Icons.file_upload),
                    onTap: getImage,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _dodajKorisnika();
                //Navigator.pop(context);
              },
              child: const Text('Spremi'),
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
      'datumRodjenja',
      'datumPocetkaTreniranja',
      'visina',
      'tezina'
    ];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
  }

  void _dodajKorisnika() async {
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
    String formattedDate1 = request['datumRodjenja'].toIso8601String();
    String formattedDate2 = request['datumPocetkaTreniranja'].toIso8601String();
    request['datumRodjenja'] = formattedDate1;
    request['datumPocetkaTreniranja'] = formattedDate2;
    request['slika'] = _base64Image;
    request['passwordPotvrda'] = request['password'];
    request['ulogaId'] = 1;

    try {
      await _korisniciProvider.insert(request);
      _showAlertDialog(
          "Uspješan unos", "Korisnik uspješno registrovan.", Colors.green);
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
