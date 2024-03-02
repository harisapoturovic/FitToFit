import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/pages/treneri_edit.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
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
        'datumZaposlenja': dateFormat.format(widget.trener.datumZaposlenja!),
        "spol": widget.trener.spol,
        "adresa": widget.trener.adresa,
        "telefon": widget.trener.telefon,
        "email": widget.trener.email,
        "zvanje": widget.trener.zvanje,
        "slika": widget.trener.slika,
        "ocjene": widget.trener.ocjene
      };
    } else {
      userImage = Image.asset('assets/images/user.png');
      _initialValue = {
        "id": widget.trener.trenerId,
        'ime': widget.trener.ime,
        'prezime': widget.trener.prezime,
        'datumZaposlenja': dateFormat.format(widget.trener.datumZaposlenja!),
        "spol": widget.trener.spol,
        "adresa": widget.trener.adresa,
        "telefon": widget.trener.telefon,
        "email": widget.trener.email,
        "zvanje": widget.trener.zvanje,
        "slika": widget.trener.slika,
        "ocjene": widget.trener.ocjene
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
    final trenerId = widget.trener.trenerId;
    var data = await _treneriProvider.getById(trenerId!);
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
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
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
      title: ("Detalji o treneru"),
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
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Ime",
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
                                name: "ime",
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
                                  labelText: "Prezime",
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
                                name: "prezime",
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
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "E-mail",
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
                                name: "email",
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
                                  labelText: "Telefon",
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
                                name: "telefon",
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
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Datum zaposlenja",
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
                                name: "datumZaposlenja",
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
                                  labelText: "Zvanje",
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
                                name: "zvanje",
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
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Adresa",
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
                                name: "adresa",
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
                                  labelText: "Spol",
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {/*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserScreen(
                            userId: odabraniTrener!.trenerId!,
                            refreshDataCallback: null,
                          ),
                        ),
                      );*/
                    },
                    child: Text('Uredi trenera'),
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
                        _confirmDeleteTrainer(context);
                      } on Exception catch (e) {
                        _showAlertDialog("Greška", e.toString(), Colors.red);
                      }
                    },
                    child: Text('Obriši trenera'),
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

  void _confirmDeleteTrainer(BuildContext context) {
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
          content: Text('Da li ste sigurni da želite izbrisati ovog trenera?'),
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
                _deleteTrainer();
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

  void _deleteTrainer() async {
    try {
      if (odabraniTrener?.trenerId != null) {
        await _treneriProvider.delete(odabraniTrener!.trenerId!);
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
}
