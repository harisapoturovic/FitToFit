import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fittofit_admin/pages/change_password.dart';
import 'package:fittofit_admin/pages/change_username.dart';
import 'package:fittofit_admin/pages/login.dart';
import 'package:image/image.dart' as img;

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class AdminProfilPage extends StatefulWidget {
  final Korisnici korisnik;
  const AdminProfilPage({Key? key, required this.korisnik}) : super(key: key);

  @override
  State<AdminProfilPage> createState() => _AdminProfilPageState();
}

class _AdminProfilPageState extends State<AdminProfilPage> {
  late KorisniciProvider _korisniciProvider;
  Korisnici? odabraniKorisnik;
  bool isLoading = true;
  Image? userImage;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    super.initState();
    if ((widget.korisnik.slika != null && widget.korisnik.slika!.isNotEmpty)) {
      userImage = imageFromBase64String(widget.korisnik.slika!);
      _initialValue = {
        "id": widget.korisnik.korisnikId,
        'ime': widget.korisnik.ime,
        'prezime': widget.korisnik.prezime,
        'korisnickoIme': widget.korisnik.korisnickoIme,
        'datumRodjenja': dateFormat.format(widget.korisnik.datumRodjenja!),
        "spol": widget.korisnik.spol,
        "adresa": widget.korisnik.adresa,
        "telefon": widget.korisnik.telefon,
        "email": widget.korisnik.email,
        "slika": widget.korisnik.slika
      };
    } else {
      userImage = Image.asset('assets/images/user.png');
      _initialValue = {
        "id": widget.korisnik.korisnikId,
        'ime': widget.korisnik.ime,
        'prezime': widget.korisnik.prezime,
        'korisnickoIme': widget.korisnik.korisnickoIme,
        'datumRodjenja': dateFormat.format(widget.korisnik.datumRodjenja!),
        "spol": widget.korisnik.spol,
        "telefon": widget.korisnik.telefon,
        "email": widget.korisnik.email,
        "slika": widget.korisnik.slika
      };
    }
    _korisniciProvider = context.read<KorisniciProvider>();
    initForm();
    _loadData();
    _korisniciProvider.addListener(() {
      _reloadKorisniciList();
    });
  }

  void _reloadKorisniciList() async {
    var data = await _korisniciProvider.getById(widget.korisnik.korisnikId);
    if (mounted) {
      setState(() {
        odabraniKorisnik = data;
        userImage = imageFromBase64String(data.slika);
      });
    }
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  void _loadData() async {
    if (!mounted) return;
    final korisnikid = widget.korisnik.korisnikId;
    var data = await _korisniciProvider.getById(korisnikid);
    if (mounted) {
      setState(() {
        odabraniKorisnik = data;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Moj profil"),
      selectedIndex: 0,
      showBackArrow: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              isLoading ? Container() : _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SizedBox(
              width: 800,
              height: 650,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRect(
                          child: userImage != null
                              ? Container(
                                  width: 250.0,
                                  height: 250.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 4.0,
                                    ),
                                    borderRadius: BorderRadius.circular(200.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200.0),
                                    child: Image(
                                      image: userImage!.image,
                                      width: 250.0,
                                      height: 250.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 250.0,
                                  height: 250.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 4.0,
                                    ),
                                    borderRadius: BorderRadius.circular(200.0),
                                  ),
                                  child: Image.asset('assets/images/user.png'),
                                ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${odabraniKorisnik?.ime} ${odabraniKorisnik?.prezime}',
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 99, 181)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    odabraniKorisnik?.email ?? '',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Color.fromARGB(255, 0, 99, 181)),
                                  ),
                                  const SizedBox(height: 30),
                                  ElevatedButton(
                                    onPressed: () {
                                      showEditUser(odabraniKorisnik!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 33, 65, 243),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text('Uredi'),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordScreen(
                                            userId:
                                                odabraniKorisnik!.korisnikId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child: const Text('Promijeni lozinku'),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeUsernameScreen(
                                            userId:
                                                odabraniKorisnik!.korisnikId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child:
                                        const Text('Promijeni korisničko ime'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Authorization.username = null;
                                            Authorization.password = null;

                                            Provider.of<KorisniciProvider>(
                                                    context,
                                                    listen: false)
                                                .setCurrentUserId(null);

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => LoginPage()),
                                              (route) => false,
                                            );
                                          },
                                          icon: const Icon(Icons.logout),
                                          iconSize: 30.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Text(
                                          'Odjavi se',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 100),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "~ Detalji o adminu ~ \n\n Broj telefona:  ${odabraniKorisnik?.telefon ?? ''} \n Spol: ${odabraniKorisnik?.spol ?? ''} \n Adresa: ${odabraniKorisnik?.adresa ?? ''} \n Datum rođenja: ${odabraniKorisnik?.datumRodjenja != null ? dateFormat.format(odabraniKorisnik!.datumRodjenja!) : ''} \n Korisničko ime: ${odabraniKorisnik?.korisnickoIme ?? ''}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  showEditUser(Korisnici korisnik) async {
    String? userImage = korisnik.slika;

    final TextEditingController imeController =
        TextEditingController(text: korisnik.ime);
    final TextEditingController prezimeController =
        TextEditingController(text: korisnik.prezime);
    final TextEditingController telefonController =
        TextEditingController(text: korisnik.telefon);
    final TextEditingController emailController =
        TextEditingController(text: korisnik.email);
    final TextEditingController adresaController =
        TextEditingController(text: korisnik.adresa);
    final TextEditingController korisnickoImeController =
        TextEditingController(text: korisnik.korisnickoIme);

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj podatke o adminu'),
                content: SingleChildScrollView(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(children: [
                    FormBuilder(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 800),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderTextField(
                                              name: 'ime',
                                              controller: imeController,
                                              decoration: const InputDecoration(
                                                labelText: 'Ime',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Ovo polje je obavezno!';
                                                }
                                                if (!RegExp(r'^[A-Z-ŠĐČĆŽ]')
                                                    .hasMatch(value)) {
                                                  return 'Ime mora početi velikim slovom.';
                                                }

                                                if (!RegExp(
                                                        r'^[a-zA-ZšđčćžŠĐČĆŽ]+$')
                                                    .hasMatch(value)) {
                                                  return 'Ime može sadržavati samo slova.';
                                                }

                                                return null;
                                              }),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'prezime',
                                            controller: prezimeController,
                                            decoration: const InputDecoration(
                                              labelText: 'Prezime',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (!RegExp(r'^[A-Z-ŠĐČĆŽ]')
                                                  .hasMatch(value)) {
                                                return 'Prezime mora početi velikim slovom.';
                                              }

                                              if (!RegExp(
                                                      r'^[a-zA-ZšđčćžŠĐČĆŽ]+$')
                                                  .hasMatch(value)) {
                                                return 'Prezime može sadržavati samo slova.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            controller: telefonController,
                                            decoration: const InputDecoration(
                                              labelText: 'Telefon',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  !RegExp(r'^[0-9]+$')
                                                      .hasMatch(value)) {
                                                return 'Ovo polje može sadržavati samo brojeve.';
                                              }
                                              if (value != null &&
                                                  value.length > 10) {
                                                return 'Broj telefona može imati maksimalno 10 cifara.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'email',
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                              labelText: 'E-mail',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  value.isNotEmpty) {
                                                if (!RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(value)) {
                                                  return 'Unesite validnu e-mail adresu.';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'adresa',
                                            controller: adresaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Adresa',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  value.isNotEmpty &&
                                                  !RegExp(r'^[A-Z]')
                                                      .hasMatch(value)) {
                                                return 'Adresa mora početi velikim slovom.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'korisnickoIme',
                                            controller: korisnickoImeController,
                                            decoration: const InputDecoration(
                                              labelText: 'Korisničko ime',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.image,
                                              );

                                              if (result != null &&
                                                  result.files.isNotEmpty) {
                                                PlatformFile file =
                                                    result.files.first;
                                                File imageFile =
                                                    File(file.path!);
                                                Uint8List imageBytes =
                                                    await imageFile
                                                        .readAsBytes();
                                                img.Image resizedImage = img
                                                    .decodeImage(imageBytes)!;
                                                int maxWidth = 800;
                                                img.Image smallerImage =
                                                    img.copyResize(resizedImage,
                                                        width: maxWidth);

                                                List<int> smallerImageBytes =
                                                    img.encodeJpg(smallerImage);

                                                String base64Image =
                                                    base64Encode(
                                                        smallerImageBytes);
                                                setState(() {
                                                  userImage = base64Image;
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                side: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 154, 231, 1)),
                                              ),
                                              textStyle: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.upload_file),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Izaberite novu sliku admina',
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                if (odabraniKorisnik != null) {
                                                  Korisnici korisnik = Korisnici(
                                                      ime: imeController.text,
                                                      prezime: prezimeController
                                                          .text,
                                                      spol: odabraniKorisnik!
                                                          .spol,
                                                      korisnikId:
                                                          odabraniKorisnik!
                                                              .korisnikId,
                                                      telefon: telefonController
                                                          .text,
                                                      email:
                                                          emailController.text,
                                                      adresa:
                                                          adresaController.text,
                                                      datumRodjenja:
                                                          odabraniKorisnik!
                                                              .datumRodjenja,
                                                      datumPocetkaTreniranja:
                                                          odabraniKorisnik!
                                                              .datumPocetkaTreniranja,
                                                      slika: userImage,
                                                      visina: odabraniKorisnik!
                                                          .visina,
                                                      tezina: odabraniKorisnik!
                                                          .tezina,
                                                      korisnickoIme:
                                                          korisnickoImeController
                                                              .text);

                                                  _korisniciProvider.update(
                                                      odabraniKorisnik!
                                                          .korisnikId,
                                                      korisnik);
                                                  _showAlertDialog(
                                                      "Uspješan edit",
                                                      "Podaci o adminu uspješno ažurirani.",
                                                      Colors.green);
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      0, 154, 231, 1),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 15),
                                              textStyle: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            child: const Text('Sačuvaj'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                            ]),
                      ),
                    )
                  ]),
                )));
          });
        });
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
