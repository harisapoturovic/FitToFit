import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class TreneriDetaljiPage extends StatefulWidget {
  final Treneri trener;
  const TreneriDetaljiPage({Key? key, required this.trener}) : super(key: key);

  @override
  State<TreneriDetaljiPage> createState() => _TreneriDetaljiPageState();
}

class _TreneriDetaljiPageState extends State<TreneriDetaljiPage> {
  late TreneriProvider _treneriProvider;
  Treneri? odabraniTrener;
  bool isLoading = true;
  Image? userImage;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    super.initState();
    if ((widget.trener.slika != null && widget.trener.slika!.isNotEmpty)) {
      userImage = imageFromBase64String(widget.trener.slika!);
      _initialValue = {
        "id": widget.trener.trenerId,
        'ime': widget.trener.ime,
        'prezime': widget.trener.prezime,
        'datumZaposlenja': dateFormat.format(widget.trener.datumZaposlenja),
        "spol": widget.trener.spol,
        "adresa": widget.trener.adresa,
        "telefon": widget.trener.telefon,
        "email": widget.trener.email,
        "zvanje": widget.trener.zvanje,
        "slika": widget.trener.slika,
        "ocjene": widget.trener.ocjenes
      };
    } else {
      userImage = Image.asset('assets/images/user.png');
      _initialValue = {
        "id": widget.trener.trenerId,
        'ime': widget.trener.ime,
        'prezime': widget.trener.prezime,
        'datumZaposlenja': dateFormat.format(widget.trener.datumZaposlenja),
        "spol": widget.trener.spol,
        "adresa": widget.trener.adresa,
        "telefon": widget.trener.telefon,
        "email": widget.trener.email,
        "zvanje": widget.trener.zvanje,
        "slika": widget.trener.slika,
        "ocjene": widget.trener.ocjenes
      };
    }
    _treneriProvider = context.read<TreneriProvider>();
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
    final trenerId = widget.trener.trenerId;
    var data = await _treneriProvider.getById(trenerId);
    setState(() {
      odabraniTrener = data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Detalji o treneru"),
      selectedIndex: 1,
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
                    padding:
                        const EdgeInsets.only(top: 100, left: 40, right: 40),
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
                                  labelText: "Datum zaposlenja",
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
                                name: "datumZaposlenja",
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
                                  labelText: "Zvanje",
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
                                name: "zvanje",
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
                        )
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
                      showEditTrainer(odabraniTrener!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      side: const BorderSide(color: Colors.white),
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    child: const Text('Uredi trenera'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        _confirmDeleteTrainer(context);
                      } on Exception catch (e) {
                        _showAlertDialog("Greška", e.toString(), Colors.red);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      side: const BorderSide(color: Colors.white),
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    child: const Text('Obriši trenera'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTrainer(BuildContext context) {
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
          content:
              const Text('Da li ste sigurni da želite izbrisati ovog trenera?'),
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
                _deleteTrainer();
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

  void _deleteTrainer() async {
    try {
      if (odabraniTrener?.trenerId != null) {
        await _treneriProvider.delete(odabraniTrener!.trenerId);
        _showAlertDialog(
            "Uspješno brisanje", "Trener uspješno izbrisan.", Colors.green);
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

  showEditTrainer(Treneri trener) async {
    String? trainerImage = trener.slika;

    final TextEditingController imeController =
        TextEditingController(text: trener.ime);
    final TextEditingController prezimeController =
        TextEditingController(text: trener.prezime);
    final TextEditingController telefonController =
        TextEditingController(text: trener.telefon);
    final TextEditingController emailController =
        TextEditingController(text: trener.email);
    final TextEditingController adresaController =
        TextEditingController(text: trener.adresa);
    final TextEditingController zvanjeController =
        TextEditingController(text: trener.zvanje);

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj trenera'),
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

                                                if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]+$')
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

                                              if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]+$')
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
                                            name: 'zvanje',
                                            controller: zvanjeController,
                                            decoration: const InputDecoration(
                                              labelText: 'Zvanje',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  value.isNotEmpty &&
                                                  !RegExp(r'^[A-Z]')
                                                      .hasMatch(value)) {
                                                return 'Zvanje mora početi velikim slovom.';
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
                                                  trainerImage = base64Image;
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
                                                  'Izaberite novu sliku trenera',
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
                                                if (odabraniTrener != null) {
                                                  Treneri trener = Treneri(
                                                    ime: imeController.text,
                                                    prezime:
                                                        prezimeController.text,
                                                    spol: odabraniTrener!.spol,
                                                    trenerId: odabraniTrener!
                                                        .trenerId,
                                                    telefon:
                                                        telefonController.text,
                                                    email: emailController.text,
                                                    adresa:
                                                        adresaController.text,
                                                    zvanje:
                                                        zvanjeController.text,
                                                    slika: trainerImage,
                                                    datumZaposlenja:
                                                        odabraniTrener!
                                                            .datumZaposlenja,
                                                  );

                                                  _treneriProvider.update(
                                                      odabraniTrener!.trenerId,
                                                      trener);
                                                  _showAlertDialog(
                                                      "Uspješan edit",
                                                      "Podaci trenera uspješno ažurirani.",
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
}
