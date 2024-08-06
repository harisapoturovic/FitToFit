import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

class KorisniciDetaljiPage extends StatefulWidget {
  final Korisnici korisnik;
  const KorisniciDetaljiPage({Key? key, required this.korisnik})
      : super(key: key);

  @override
  State<KorisniciDetaljiPage> createState() => _KorisniciDetaljiPageState();
}

class _KorisniciDetaljiPageState extends State<KorisniciDetaljiPage> {
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
        'datumPocetkaTreniranja':
            dateFormat.format(widget.korisnik.datumPocetkaTreniranja!),
        "spol": widget.korisnik.spol,
        "adresa": widget.korisnik.adresa,
        "telefon": widget.korisnik.telefon,
        "email": widget.korisnik.email,
        "tezina": widget.korisnik.tezina.toString(),
        "visina": widget.korisnik.visina.toString(),
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
        'datumPocetkaTreniranja':
            dateFormat.format(widget.korisnik.datumPocetkaTreniranja!),
        "spol": widget.korisnik.spol,
        "adresa": widget.korisnik.adresa,
        "telefon": widget.korisnik.telefon,
        "tezina": widget.korisnik.tezina.toString(),
        "visina": widget.korisnik.visina.toString(),
        "email": widget.korisnik.email,
        "slika": widget.korisnik.slika
      };
    }
    _korisniciProvider = context.read<KorisniciProvider>();
    initForm();
    _loadData();
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
    setState(() {
      odabraniKorisnik = data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Detalji o korisniku"),
      selectedIndex: 1,
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
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 40, right: 40),
            child: Container(
              decoration: const BoxDecoration(),
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400.0,
                      maxHeight: 520.0,
                    ),
                    child: ClipRect(
                      child: userImage != null
                          ? Container(
                              width: 400.0,
                              height: 500.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(0, 154, 231, 1),
                                  width: 4.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image(
                                  image: userImage!.image,
                                  width: 400.0,
                                  height: 400.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 400.0,
                              height: 400.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(0, 154, 231, 1),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Image.asset('assets/images/user.png'),
                            ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: SizedBox(
                  width: 900,
                  height: 520,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Ime",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "ime",
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Prezime",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "prezime",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "E-mail",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "email",
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Telefon",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "telefon",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Datum rođenja",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "datumRodjenja",
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Datum početka treniranja",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "datumPocetkaTreniranja",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Korisničko ime",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "korisnickoIme",
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Spol",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "spol",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Visina",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "visina",
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Težina",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "tezina",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Adresa",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "adresa",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showEditUser(odabraniKorisnik!);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      side: const BorderSide(color: Colors.white),
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    child: const Text('Uredi korisnika'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        _confirmDeleteUser(context);
                      } on Exception catch (e) {
                        _showAlertDialog("Greška", e.toString(), Colors.red);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      side: const BorderSide(color: Colors.white),
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    child: const Text('Obriši korisnika'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda brisanja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
              'Da li ste sigurni da želite izbrisati ovog korisnika?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Odustani',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteUser();
                Navigator.pop(context);
              },
              child: const Text(
                'Izbriši',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  void _deleteUser() async {
    try {
      if (odabraniKorisnik?.korisnikId != null) {
        await _korisniciProvider.delete(odabraniKorisnik!.korisnikId);
        _showAlertDialog(
            "Uspješno brisanje", "Korisnik uspješno izbrisan.", Colors.green);
      }
    } catch (e) {
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
    final TextEditingController visinaController =
        TextEditingController(text: korisnik.visina);
    final TextEditingController tezinaController =
        TextEditingController(text: korisnik.tezina);
    final TextEditingController korisnickoImeController =
        TextEditingController(text: korisnik.korisnickoIme);

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj korisnika'),
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
                                                if (!RegExp(r'^[A-Z]')
                                                    .hasMatch(value)) {
                                                  return 'Ime mora početi velikim slovom.';
                                                }

                                                if (!RegExp(r'^[A-Za-z]*$')
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
                                              if (!RegExp(r'^[A-Z]')
                                                  .hasMatch(value)) {
                                                return 'Prezime mora početi velikim slovom.';
                                              }

                                              if (!RegExp(r'^[A-Za-z]*$')
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
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'visina',
                                            controller: visinaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Visina (cm)',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno';
                                              }
                                              final heightRegex = RegExp(
                                                  r'^\d+(\s*\d*)?\s*(cm|m)$');
                                              if (!heightRegex
                                                  .hasMatch(value)) {
                                                return 'Unesite validnu vrijednost za visinu.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'tezina',
                                            controller: tezinaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Težina (kg)',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno';
                                              }
                                              final heightRegex =
                                                  RegExp(r'^\d+(\.\d+)?\s*kg$');
                                              if (!heightRegex
                                                  .hasMatch(value)) {
                                                return 'Unesite validnu vrijednost za težinu.';
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.upload_file),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Izaberite novu sliku korisnika',
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
                                                      visina:
                                                          visinaController.text,
                                                      tezina:
                                                          tezinaController.text,
                                                      korisnickoIme:
                                                          korisnickoImeController
                                                              .text);

                                                  _korisniciProvider.update(
                                                      odabraniKorisnik!
                                                          .korisnikId,
                                                      korisnik);
                                                  _showAlertDialog(
                                                      "Uspješan edit",
                                                      "Podaci korisnika uspješno ažurirani.",
                                                      Colors.green);
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color.fromRGBO(
                                                  0, 154, 231, 1),
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
}
