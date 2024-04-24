import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/novosti.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';

class NovostiDetaljiPage extends StatefulWidget {
  final Novosti novost;
  final int adminId;
  const NovostiDetaljiPage(
      {Key? key, required this.novost, required this.adminId})
      : super(key: key);

  @override
  State<NovostiDetaljiPage> createState() => _NovostiDetaljiPageState();
}

class _NovostiDetaljiPageState extends State<NovostiDetaljiPage> {
  late NovostiProvider _novostiProvider;
  late KorisniciProvider _korisniciProvider;
  late VrsteTreningaProvider _vrsteTreningaProvider;
  Novosti? odabranaNovost;
  bool isLoading = true;
  int? _selectedVrstaTreninga;
  List<VrsteTreninga> _vrsteTreningaList = [];
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  bool isAuthor = false;

  @override
  void initState() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    super.initState();
    _initialValue = {
      "id": widget.novost.novostId,
      'naslov': widget.novost.naslov,
      'sadrzaj': widget.novost.sadrzaj,
      'isLiked': widget.novost.isLiked,
      'datumObjave': dateFormat.format(widget.novost.datumObjave),
      "brojLajkova": widget.novost.brojLajkova.toString(),
      "korisnikId": widget.novost.korisnikId.toString(),
      "vrstaTreningaId": widget.novost.vrstaTreningaId.toString()
    };

    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    initForm();
    _loadData();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  void _loadData() async {
    final novostid = widget.novost.novostId;
    var data = await _novostiProvider.getById(novostid);
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
    setState(() {
      odabranaNovost = data;
      _vrsteTreningaList = vrsteTreninga.result;
      isAuthor = odabranaNovost!.korisnikId == widget.adminId;
    });
  }

  Future<Korisnici?> getKorisnikFromNovostiId(int userId) async {
    final user = await _korisniciProvider.getById(userId);
    return user;
  }

  Future<VrsteTreninga?> getVrstaTreningaFromNovostiId(
      int vrstaTreningaId) async {
    final vrstaTr = await _vrsteTreningaProvider.getById(vrstaTreningaId);
    return vrstaTr;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: ("Detalji o objavi"),
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
                        const EdgeInsets.only(left: 40, right: 40, top: 80),
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
                                  labelText: "Naslov",
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
                                name: "naslov",
                                enabled: false,
                              ),
                            )
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
                                    height: 3),
                                decoration: const InputDecoration(
                                  labelText: "Sadržaj",
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
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                ),
                                minLines: 1,
                                maxLines: 3,
                                name: "sadrzaj",
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
                                    fontSize: 20, color: Colors.black),
                                decoration: const InputDecoration(
                                  labelText: "Broj lajkova",
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
                                name: "brojLajkova",
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
                                  labelText: "Datum objave",
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
                                name: "datumObjave",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FutureBuilder<Korisnici?>(
                                future: getKorisnikFromNovostiId(
                                    odabranaNovost!.korisnikId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final author = snapshot.data;
                                    if (author != null) {
                                      return FormBuilderTextField(
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: "Objavio",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 154, 231, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        ),
                                        name: 'korisnik',
                                        initialValue:
                                            "${author.ime} ${author.prezime}",
                                        enabled: false,
                                      );
                                    } else {
                                      return const Text(
                                          "Objavio: Nepoznat autor");
                                    }
                                  } else {
                                    return const Text("Objavio: Učitavanje...");
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FutureBuilder<VrsteTreninga?>(
                                future: getVrstaTreningaFromNovostiId(
                                    odabranaNovost!.vrstaTreningaId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final vrsta = snapshot.data;
                                    if (vrsta != null) {
                                      return FormBuilderTextField(
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: "Namjenjeno za ",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 154, 231, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        ),
                                        name: 'vrstaTreninga',
                                        initialValue: "${vrsta.naziv} trening",
                                        enabled: false,
                                      );
                                    } else {
                                      return const Text(
                                          "Namjenjeno za: Nepoznato");
                                    }
                                  } else {
                                    return const Text(
                                        "Namjenjeno za: Učitavanje...");
                                  }
                                },
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
                  isAuthor
                      ? ElevatedButton(
                          onPressed: () {
                            showEditNews(odabranaNovost!);
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
                          child: const Text('Uredi objavu'),
                        )
                      : Container(),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        _confirmDeleteNews(context);
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
                    child: const Text('Obriši objavu'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteNews(BuildContext context) {
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
              const Text('Da li ste sigurni da želite izbrisati ovu objavu?'),
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
                _deleteNews();
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

  void _deleteNews() async {
    try {
      if (odabranaNovost?.novostId != null) {
        await _novostiProvider.delete(odabranaNovost!.novostId);
        _showAlertDialog(
            "Uspješno brisanje", "Objava uspješno izbrisana.", Colors.green);
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

  showEditNews(Novosti novost) async {
    final TextEditingController naslovController =
        TextEditingController(text: novost.naslov);
    final TextEditingController sadrzajController =
        TextEditingController(text: novost.sadrzaj);

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj objavu'),
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
                                            name: 'naslov',
                                            controller: naslovController,
                                            decoration: const InputDecoration(
                                              labelText: 'Naslov',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'sadrzaj',
                                            controller: sadrzajController,
                                            decoration: const InputDecoration(
                                              labelText: 'Sadrzaj',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  value.length < 5) {
                                                return 'Morate unijeti najmanje 5 karaktera.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                                labelText: "Vrsta treninga"),
                                            value:
                                                odabranaNovost!.vrstaTreningaId,
                                            items: _vrsteTreningaList
                                                .map((VrsteTreninga vrsta) {
                                              return DropdownMenuItem(
                                                value: vrsta.vrstaTreningaId,
                                                child: Text(vrsta.naziv!),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedVrstaTreninga =
                                                    value as int?;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                if (odabranaNovost != null) {
                                                  Novosti novost = Novosti(
                                                      novostId: odabranaNovost!
                                                          .novostId,
                                                      naslov:
                                                          naslovController.text,
                                                      sadrzaj: sadrzajController
                                                          .text,
                                                      datumObjave:
                                                          DateTime.now(),
                                                      isLiked: odabranaNovost!
                                                          .isLiked,
                                                      brojLajkova:
                                                          odabranaNovost!
                                                              .brojLajkova,
                                                      korisnikId:
                                                          odabranaNovost!
                                                              .korisnikId,
                                                      vrstaTreningaId:
                                                          _selectedVrstaTreninga ?? odabranaNovost!.vrstaTreningaId);

                                                  _novostiProvider.update(
                                                      odabranaNovost!.novostId,
                                                      novost);
                                                  _showAlertDialog(
                                                      "Uspješan edit",
                                                      "Podaci o objavi uspješno ažurirani.",
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
