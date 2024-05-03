import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fittofit_admin/providers/vjezbe_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:image/image.dart' as img;
import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/models/vjezbe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class VjezbaCard extends StatefulWidget {
  final Vjezbe vjezba;
  const VjezbaCard({Key? key, required this.vjezba}) : super(key: key);

  @override
  State<VjezbaCard> createState() => _VjezbaCardState();
}

class _VjezbaCardState extends State<VjezbaCard> {
  late VjezbeProvider _vjezbeProvider;
  Image? slika;

  @override
  void initState() {
    super.initState();
    _vjezbeProvider = context.read<VjezbeProvider>();
    slika = imageFromBase64String(widget.vjezba.slika!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child:
                  widget.vjezba.slika != null && widget.vjezba.slika!.isNotEmpty
                      ? Container(
                          width: 250.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: slika!.image,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 250.0,
                          height: 150.0,
                          child: Image.asset('assets/images/vjezba.jpg',
                              fit: BoxFit.cover),
                        ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.vjezba.naziv,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.vjezba.opis}',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: "Uredi",
                textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    showEditVjezbe(context);
                  },
                ),
              ),
              Tooltip(
                message: 'Izbriši',
                textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    _confirmDeleteVjezbu(context);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  showEditVjezbe(BuildContext context) async {
    String? slika = widget.vjezba.slika;
    final TextEditingController opisController =
        TextEditingController(text: widget.vjezba.opis);
    final TextEditingController nazivController =
        TextEditingController(text: widget.vjezba.naziv);

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj vježbu'),
                content: SingleChildScrollView(
                    child: Container(
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
                                            name: 'naziv',
                                            controller: nazivController,
                                            decoration: const InputDecoration(
                                              labelText: 'Naziv',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (!RegExp(r'^[A-Z]')
                                                  .hasMatch(value)) {
                                                return 'Naziv mora početi velikim slovom.';
                                              }

                                              if (value.length > 50) {
                                                return 'Možete unijeti maksimalno 50 karaktera.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderTextField(
                                            name: 'opis',
                                            controller: opisController,
                                            decoration: const InputDecoration(
                                              labelText: 'Opis',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (value.length < 5) {
                                                return 'Morate unijeti najmanje 5 karaktera.';
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
                                                  slika = base64Image;
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
                                                  'Izaberite novu sliku za vježbu',
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
                                                Vjezbe v = Vjezbe(
                                                    vjezbaId:
                                                        widget.vjezba.vjezbaId,
                                                    naziv: nazivController.text,
                                                    opis: opisController.text,
                                                    slika: slika);

                                                _vjezbeProvider.update(
                                                    widget.vjezba.vjezbaId, v);
                                                _showAlertDialog(
                                                    "Uspješan edit",
                                                    "Podaci o vježbi uspješno ažurirani.",
                                                    Colors.green);
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

  void _confirmDeleteVjezbu(BuildContext context) {
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
              const Text('Da li ste sigurni da želite izbrisati ovu vježbu?'),
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
                _obrisiVjezbu();
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

  void _obrisiVjezbu() async {
    try {
      await _vjezbeProvider.delete(widget.vjezba.vjezbaId);
      _showAlertDialog(
          "Uspješno brisanje", "Vježba uspješno izbrisana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }
}
