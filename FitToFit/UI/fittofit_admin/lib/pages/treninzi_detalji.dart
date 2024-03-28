import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fittofit_admin/models/termini.dart';
import 'package:fittofit_admin/providers/termini_provider.dart';
import 'package:image/image.dart' as img;

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:fittofit_admin/utils/util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';

class TreninziDetaljiPage extends StatefulWidget {
  final Treninzi trening;
  const TreninziDetaljiPage({Key? key, required this.trening})
      : super(key: key);

  @override
  State<TreninziDetaljiPage> createState() => _TreninziDetaljiPageState();
}

class _TreninziDetaljiPageState extends State<TreninziDetaljiPage> {
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreninziProvider _treninziProvider;
  late TerminiProvider _terminiProvider;
  Treninzi? odabraniTrening;
  bool isLoading = true;
  Image? trainingImage;
  int? _selectedVrstaTreninga;
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Termini> _terminiResult = [];
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    if ((widget.trening.slika != null && widget.trening.slika!.isNotEmpty)) {
      trainingImage = imageFromBase64String(widget.trening.slika!);
      _initialValue = {
        "id": widget.trening.treningId,
        "naziv": widget.trening.naziv,
        'opis': widget.trening.opis,
        'maxBrojClanova': widget.trening.maxBrojClanova.toString(),
        'cijenaPoTerminu': widget.trening.cijenaPoTerminu.toString(),
        "trajanje": widget.trening.trajanje,
        "prosjecnaPotrosnjaKalorija":
            widget.trening.prosjecnaPotrosnjaKalorija.toString(),
        "vrstaId": widget.trening.vrstaId.toString(),
        "namjena": widget.trening.namjena,
        "slika": widget.trening.slika,
        "termini": widget.trening.terminis
      };
    } else {
      trainingImage = Image.asset('assets/images/training.jpg');
      _initialValue = {
        "id": widget.trening.treningId,
        "naziv": widget.trening.naziv,
        'opis': widget.trening.opis,
        'maxBrojClanova': widget.trening.maxBrojClanova.toString(),
        'cijenaPoTerminu': widget.trening.cijenaPoTerminu.toString(),
        "trajanje": widget.trening.trajanje,
        "prosjecnaPotrosnjaKalorija":
            widget.trening.prosjecnaPotrosnjaKalorija.toString(),
        "vrstaId": widget.trening.vrstaId.toString(),
        "namjena": widget.trening.namjena,
        "slika": widget.trening.slika,
        "termini": widget.trening.terminis
      };
    }

    _treninziProvider = context.read<TreninziProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _terminiProvider = context.read<TerminiProvider>();
    initForm();
    _loadData();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  void _loadData() async {
    final treningid = widget.trening.treningId;
    var data = await _treninziProvider.getById(treningid);
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
    var termini = await _terminiProvider
        .get(filter: {"TreningId": "${widget.trening.treningId}"});
    setState(() {
      odabraniTrening = data;
      _vrsteTreningaList = vrsteTreninga.result;
      _terminiResult = termini.result;
    });
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Column(
              children: [
                isLoading ? Container() : _buildForm(),
              ],
            ),
          ),
        ),
      ),
      title: ("Detalji o treningu"),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 50, left: 40, right: 40),
            child: Container(
              decoration: BoxDecoration(),
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 400.0,
                      maxHeight: 520.0,
                    ),
                    child: ClipRect(
                      child: trainingImage != null
                          ? Container(
                              width: 400.0,
                              height: 520.0,
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
                                  image: trainingImage!.image,
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
                              child: Image.asset('assets/images/training.jpg'),
                            ),
                    )),
              ),
            ),
          ),
          SizedBox(
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
                  height: 600,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Naziv",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "naziv",
                                enabled: false,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    height: 3),
                                decoration: InputDecoration(
                                  labelText: "Opis",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
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
                                name: "opis",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Maksimalan broj članova",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "maxBrojClanova",
                                enabled: false,
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Cijena po terminu",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "cijenaPoTerminu",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Trajanje",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "trajanje",
                                enabled: false,
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Prosječna potrošnja kalorija",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "prosjecnaPotrosnjaKalorija",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FutureBuilder<VrsteTreninga?>(
                                future: getVrstaTreningaFromNovostiId(
                                    odabraniTrening!.vrstaId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final vrsta = snapshot.data;
                                    if (vrsta != null) {
                                      return FormBuilderTextField(
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: "Vrsta treninga",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromRGBO(
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
                                      return Text("Vrsta treninga: Nepoznato");
                                    }
                                  } else {
                                    return Text(
                                        "Vrsta treninga: Učitavanje...");
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Namjena",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "namjena",
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Termini",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromRGBO(0, 154, 231, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                name: "termini",
                                initialValue: _terminiResult.map((termini) {
                                  return '${termini.dan}${termini.sat != null ? ' u ${termini.sat}' : ''}';
                                }).join(", "),
                                enabled: false,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showEditTrainings(odabraniTrening!);
                    },
                    child: Text('Uredi objavu'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                      side: BorderSide(color: Colors.white),
                      textStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        _confirmDeleteTrainings(context);
                      } on Exception catch (e) {
                        _showAlertDialog("Greška", e.toString(), Colors.red);
                      }
                    },
                    child: Text('Obriši trening'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                      side: BorderSide(color: Colors.white),
                      textStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTrainings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 238, 247, 255),
          title: Text(
            'Potvrda brisanja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text('Da li ste sigurni da želite izbrisati ovaj trening?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Odustani',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteTraining();
                Navigator.pop(context);
              },
              child: Text(
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

  void _deleteTraining() async {
    try {
      if (odabraniTrening?.treningId != null) {
        await _treninziProvider.delete(odabraniTrening!.treningId);
        _showAlertDialog(
            "Uspješno brisanje", "Trening uspješno izbrisan.", Colors.green);
      }
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _showAlertDialog(String naslov, String poruka, Color boja) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 238, 247, 255),
        title: Text(
          naslov,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: boja,
          ),
        ),
        content: Text(
          poruka,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              primary: Colors.blue,
              textStyle: TextStyle(
                fontSize: 16.0,
              ),
            ),
            child: Text("OK"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  showEditTrainings(Treninzi trening) async {
    String? trainingImage = trening.slika;
    final TextEditingController nazivController =
        TextEditingController(text: trening.naziv);
    final TextEditingController opisController =
        TextEditingController(text: trening.opis);
    final TextEditingController maxBrojClanovaController =
        TextEditingController(text: trening.maxBrojClanova.toString());
    final TextEditingController cijenaPoTerminuController =
        TextEditingController(text: trening.cijenaPoTerminu.toString());
    final TextEditingController trajanjeController =
        TextEditingController(text: trening.trajanje);
    final TextEditingController prosjecnaPotrosnjaKalorijaClanovaController =
        TextEditingController(
            text: trening.prosjecnaPotrosnjaKalorija.toString());
    final TextEditingController namjenaController =
        TextEditingController(text: trening.namjena);

    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj trening'),
                content: SingleChildScrollView(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(children: [
                    FormBuilder(
                      key: _formKey,
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

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
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
                                              if (!RegExp(r'^[A-Z]')
                                                  .hasMatch(value)) {
                                                return 'Opis mora početi velikim slovom.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderTextField(
                                            name: 'maxBrojClanova',
                                            controller:
                                                maxBrojClanovaController,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Maksimalan broj članova',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (value != null &&
                                                  !RegExp(r'^[0-9]+$')
                                                      .hasMatch(value)) {
                                                return 'Ovo polje može sadržavati samo brojeve.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'cijenaPoTerminu',
                                            controller:
                                                cijenaPoTerminuController,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Cijena po terminu (KM)',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (value != null &&
                                                  !RegExp(r'^[0-9]+(?:[.,][0-9]+)*$')
                                                      .hasMatch(value)) {
                                                return 'Ovo polje ne može sadržavati slova.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderTextField(
                                            name: 'trajanje',
                                            controller: trajanjeController,
                                            decoration: const InputDecoration(
                                              labelText: 'Trajanje (min/h)',
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
                                            name: 'prosjecnaPotrosnjaKalorija',
                                            controller:
                                                prosjecnaPotrosnjaKalorijaClanovaController,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Prosječna potrošnja kalorija (kcal)',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (value != null &&
                                                  !RegExp(r'^[0-9]+(?:[.,][0-9]+)*$')
                                                      .hasMatch(value)) {
                                                return 'Ovo polje ne može sadržavati slova.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormBuilderTextField(
                                            name: 'namjena',
                                            controller: namjenaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Namjena',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (!RegExp(r'^[A-Z]')
                                                  .hasMatch(value)) {
                                                return 'Namjena mora početi velikim slovom.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                labelText: "Vrsta treninga"),
                                            value: odabraniTrening!.vrstaId,
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
                                                  trainingImage = base64Image;
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
                                                    color: const Color.fromRGBO(
                                                        0, 154, 231, 1)),
                                              ),
                                              textStyle: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.upload_file),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Izaberite novu sliku za trening',
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                if (odabraniTrening != null) {
                                                  Treninzi trening = Treninzi(
                                                      treningId: odabraniTrening!
                                                          .treningId,
                                                      naziv:
                                                          nazivController.text,
                                                      opis: opisController.text,
                                                      maxBrojClanova:
                                                          int.tryParse(maxBrojClanovaController.text) ??
                                                              0,
                                                      cijenaPoTerminu: double.tryParse(
                                                              cijenaPoTerminuController
                                                                  .text) ??
                                                          0.0,
                                                      trajanje:
                                                          trajanjeController
                                                              .text,
                                                      prosjecnaPotrosnjaKalorija:
                                                          double.tryParse(prosjecnaPotrosnjaKalorijaClanovaController.text) ??
                                                              0.0,
                                                      namjena: namjenaController
                                                          .text,
                                                      vrstaId:
                                                          _selectedVrstaTreninga ??
                                                              0,
                                                      slika: trainingImage,
                                                      terminis: odabraniTrening
                                                              ?.terminis ??
                                                          []);

                                                  _treninziProvider.update(
                                                      odabraniTrening!
                                                          .treningId,
                                                      trening);
                                                  _showAlertDialog(
                                                      "Uspješan edit",
                                                      "Podaci o treningu uspješno ažurirani.",
                                                      Colors.green);
                                                }
                                              }
                                            },
                                            child: const Text('Sačuvaj'),
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
