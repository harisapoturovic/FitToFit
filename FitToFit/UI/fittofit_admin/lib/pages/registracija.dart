import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = true;
  Korisnici? korisnik;
  late KorisniciProvider _korisniciProvider;
  DateTime? _selectedDate;
  final FocusNode _imeFocusNode = FocusNode();
  final FocusNode _prezimeFocusNode = FocusNode();
  final FocusNode _telefonFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _adresaFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _lozinkaFocusNode = FocusNode();
  bool usernameTaken = false;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String? _selectedSpol;
  List<String> spolovi = [];

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    initForm();
    spolovi = ['Muški', 'Ženski'];
  }

  @override
  void dispose() {
    _imeFocusNode.dispose();
    _prezimeFocusNode.dispose();
    _telefonFocusNode.dispose();
    _emailFocusNode.dispose();
    _adresaFocusNode.dispose();
    _usernameFocusNode.dispose();
    _lozinkaFocusNode.dispose();
    super.dispose();
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

  Future<void> provjeriUsername(String username) async {
    try {
      var temp = await _korisniciProvider
          .get(filter: {"korisnickoIme": username, "isAdmin": true});
      if (mounted) {
        setState(() {
          usernameTaken = temp.count > 0;
        });
      }
    } catch (e) {
      print('Greška pri provjeri username-a: $e');
    }
  }

  Future<void> debouncedUsernameCheck(String username) async {
    debouncer.run(() async {
      await provjeriUsername(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Registracija",
      selectedIndex: 0,
      showBackArrow: true,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_imeFocusNode);
    });

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
                        focusNode: _imeFocusNode,
                        controller: imeController,
                        decoration: const InputDecoration(labelText: "Ime"),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_prezimeFocusNode),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          } else if (!RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                            return 'Ime mora početi velikim slovom.';
                          } else if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ\s]+$')
                              .hasMatch(value)) {
                            return 'Ime može sadržavati samo slova.';
                          } else if (value.length < 3) {
                            return 'Morate unijeti najmanje 3 karaktera.';
                          } else if (value.length > 50) {
                            return 'Premašili ste maksimalan broj karaktera (50).';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "prezime",
                        focusNode: _prezimeFocusNode,
                        controller: prezimeController,
                        decoration: const InputDecoration(labelText: "Prezime"),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_telefonFocusNode),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          } else if (!RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                            return 'Prezime mora početi velikim slovom.';
                          } else if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ\s]+$')
                              .hasMatch(value)) {
                            return 'Prezime može sadržavati samo slova.';
                          } else if (value.length < 3) {
                            return 'Morate unijeti najmanje 3 karaktera.';
                          } else if (value.length > 50) {
                            return 'Premašili ste maksimalan broj karaktera (50).';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderDropdown(
                        name: 'spol',
                        decoration: const InputDecoration(labelText: 'Spol'),
                        initialValue: _selectedSpol,
                        items: spolovi.map((spol) {
                          return DropdownMenuItem(
                            value: spol,
                            child: Text(spol),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSpol = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Ovo polje je obavezno!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                          name: "telefon",
                          focusNode: _telefonFocusNode,
                          controller: telefonController,
                          decoration:
                              const InputDecoration(labelText: "Telefon"),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Ovo polje može sadržavati samo brojeve.';
                              } else if (value.length < 9) {
                                return 'Broj telefona može imati minimalno 9 cifara.';
                              } else if (value.length > 10) {
                                return 'Broj telefona može imati maksimalno 10 cifara.';
                              }
                            }
                            return null;
                          }),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "email",
                        focusNode: _emailFocusNode,
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "E-mail"),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_adresaFocusNode),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Unesite validnu e-mail adresu.';
                            } else if (value.length > 50) {
                              return 'Premašili ste maksimalan broj karaktera (50).';
                            }
                          }
                          return null;
                        },
                      ),
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
                        focusNode: _adresaFocusNode,
                        decoration: const InputDecoration(labelText: 'Adresa'),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_usernameFocusNode),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.isNotEmpty &&
                                !RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                              return 'Adresa mora početi velikim slovom.';
                            } else if (value.length < 3) {
                              return 'Morate unijeti najmanje 3 karaktera.';
                            } else if (value.length > 50) {
                              return 'Premašili ste maksimalan broj karaktera (50).';
                            }
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
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
                            firstDate: DateTime.utc(1943, 12, 31),
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            _selectedDate = date;
                          });
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
                              "Izaberite datum rođenja",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      _selectedDate != null
                          ? Text(
                              "Izabrani datum rođenja: ${_selectedDate?.day}.${_selectedDate?.month}.${_selectedDate?.year}.",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "korisnickoIme",
                        focusNode: _usernameFocusNode,
                        controller: korisnickoImeController,
                        decoration: InputDecoration(
                          labelText: "Korisničko ime",
                          errorText: usernameTaken
                              ? "Admin sa ovim korisničkim imenom već postoji."
                              : null,
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_lozinkaFocusNode),
                        onChanged: (val) async {
                          if (val != null && val.isNotEmpty) {
                            debouncedUsernameCheck(val);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          } else if (value.length < 5) {
                            return 'Morate unijeti najmanje 5 karaktera.';
                          } else if (value.length > 50) {
                            return 'Premašili ste maksimalan broj karaktera (50).';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: "password",
                        focusNode: _lozinkaFocusNode,
                        controller: lozinkaController,
                        decoration: const InputDecoration(labelText: "Lozinka"),
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          _dodajAdmina();
                          FocusScope.of(context).unfocus();
                        },
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
                              title: const Text("Odaberite sliku"),
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
                          backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
                          foregroundColor: Colors.white,
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

  void _dodajAdmina() {
    late String datumVrijeme;
    if (_selectedDate != null) {
      String datum_ = _selectedDate.toString();
      datumVrijeme =
          DateTime.parse(datum_.replaceAll(' ', 'T')).toIso8601String();
    }

    _formKey.currentState?.saveAndValidate();
    if (_formKey.currentState!.validate()) {
      var request = Map.from(_formKey.currentState!.value);
      if (_selectedDate != null) {
        request.addAll({
          'datumRodjenja': datumVrijeme,
        });
      }
      request['slika'] = _base64Image;
      request['passwordPotvrda'] = request['password'];
      request['ulogaId'] = 2;

      try {
        _korisniciProvider.insert(request);
        if (mounted) {
          setState(() {
            _formKey.currentState?.reset();
            _selectedDate = null;
            _selectedSpol = null;
            spolovi = [];
            imeController.clear();
            prezimeController.clear();
            spolController.clear();
            telefonController.clear();
            emailController.clear();
            adresaController.clear();
            korisnickoImeController.clear();
            lozinkaController.clear();
            spolovi = ['Muški', 'Ženski'];
          });
        }
        _showAlertDialog(
            "Uspješan unos", "Admin uspješno dodat.", Colors.green);
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
