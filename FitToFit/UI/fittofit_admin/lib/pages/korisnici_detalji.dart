import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
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
    final korisnikid = widget.korisnik.korisnikId;
    var data = await _korisniciProvider.getById(korisnikid!);
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
      title: ("Detalji o korisniku"),
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
          SizedBox(height: 30,),
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
                                  labelText: "Datum rođenja",
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
                                name: "datumRodjenja",
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
                                  labelText: "Datum početka treniranja",
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
                                name: "datumPocetkaTreniranja",
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
                                  labelText: "Korisničko ime",
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
                                name: "korisnickoIme",
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
                                  labelText: "Visina",
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
                                name: "visina",
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
                                  labelText: "Težina",
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
                                name: "tezina",
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),              
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Uredi korisnika'),
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
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        _confirmDeleteUser(context);
                      } on Exception catch (e) {
                        _showAlertDialog("Greška", e.toString(), Colors.red);
                      }
                    },
                    child: Text('Obriši korisnika'),
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

  void _confirmDeleteUser(BuildContext context) {
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
          content:
              Text('Da li ste sigurni da želite izbrisati ovog korisnika?'),
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
                _deleteUser();
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

  void _deleteUser() async {
    try {
      if (odabraniKorisnik?.korisnikId != null) {
        await _korisniciProvider.delete(odabraniKorisnik!.korisnikId!);
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
