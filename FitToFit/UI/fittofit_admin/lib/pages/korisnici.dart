import 'dart:convert';
import 'dart:io';

import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/search_result.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
import '../widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';

class KorisniciPage extends StatefulWidget {
  const KorisniciPage({Key? key}) : super(key: key);

  @override
  State<KorisniciPage> createState() => _KorisniciPageState();
}

class _KorisniciPageState extends State<KorisniciPage> {
  late KorisniciProvider _korisniciProvider;
  late TreneriProvider _treneriProvider;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Treneri>? treneriResult;
  late final Treneri? trener;
  bool isLoading = true;
  ScrollController _userListController = ScrollController();
  ScrollController _trainerListController = ScrollController();
  TextEditingController _imeKorisnikaController = new TextEditingController();
  TextEditingController _prezimeKorisnikaController =
      new TextEditingController();
  TextEditingController _imeTreneraController = new TextEditingController();
  TextEditingController _prezimeTreneraController = new TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
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
    var data1 = await _treneriProvider.get(filter: {});
    var data2 = await _korisniciProvider.get(filter: {});

    setState(() {
      treneriResult = data1;
      korisniciResult = data2;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 50.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 130.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _imeKorisnikaController,
                          decoration: InputDecoration(
                            hintText: 'Ime',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _ucitajKorisnike();
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _prezimeKorisnikaController,
                          decoration: InputDecoration(
                            hintText: 'Prezime',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _ucitajKorisnike();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: userList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 50.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 130.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _imeTreneraController,
                          decoration: InputDecoration(
                            hintText: 'Ime',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _ucitajTrenere();
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _prezimeTreneraController,
                          decoration: InputDecoration(
                            hintText: 'Prezime',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _ucitajTrenere();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: trainerList(),
                ),
              ],
            ),
          ),
        ],
      ),
      title: "Korisnici & treneri",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTrainerDialog();
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  Widget userList() {
    List<Korisnici> korisnici = korisniciResult?.result ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 245, 251, 1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin:
          EdgeInsets.only(left: 130.0, right: 130.0, top: 50.0, bottom: 50.0),
      padding: EdgeInsets.all(50.0),
      child: Scrollbar(
        controller: _userListController,
        child: ListView.builder(
          controller: _userListController,
          itemCount: korisnici.length,
          itemBuilder: (context, index) {
            Korisnici korisnik = korisnici[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 50.0),
                leading: Icon(
                  Icons.person,
                  color: Color.fromRGBO(0, 135, 202, 1),
                  size: 30.0,
                ),
                title: Text(
                  '${korisnik.ime ?? ''} ${korisnik.prezime ?? ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Color.fromRGBO(0, 135, 202, 1),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget trainerList() {
    List<Treneri> treneri = treneriResult?.result ?? [];

    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(242, 245, 251, 1),
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin:
            EdgeInsets.only(left: 130.0, right: 130.0, top: 50.0, bottom: 50.0),
        padding: EdgeInsets.all(50.0),
        child: Scrollbar(
          controller: _trainerListController,
          child: ListView.builder(
            controller: _trainerListController,
            itemCount: treneri.length,
            itemBuilder: (context, index) {
              Treneri trener = treneri[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 50.0),
                  leading: Icon(
                    Icons.person,
                    color: Color.fromRGBO(0, 135, 202, 1),
                    size: 30.0,
                  ),
                  title: Text(
                    '${trener.ime ?? ''} ${trener.prezime ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Color.fromRGBO(0, 135, 202, 1),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  @override
  void dispose() {
    _userListController.dispose();
    _trainerListController.dispose();
    super.dispose();
  }

  void _ucitajKorisnike() async {
    var data = await _korisniciProvider.get(filter: {
      'ime': _imeKorisnikaController.text,
      'prezime': _prezimeKorisnikaController.text,
      'IsAdmin': false
    });

    setState(() {
      korisniciResult = data;
    });
  }

  void _ucitajTrenere() async {
    var data = await _treneriProvider.get(filter: {
      'ime': _imeTreneraController.text,
      'prezime': _prezimeTreneraController.text
    });

    setState(() {
      treneriResult = data;
    });
  }

  void _showAddTrainerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dodaj novog trenera'),
          content: Container(
            width: 500.0,
            height: 700.0,
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'ime',
                      decoration: InputDecoration(labelText: 'Ime'),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'prezime',
                      decoration: InputDecoration(labelText: 'Prezime'),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderDropdown(
                      name: 'spol',
                      decoration: InputDecoration(labelText: 'Spol'),
                      initialValue: 'Muški',
                      items: ['Muški', 'Ženski'].map((spol) {
                        return DropdownMenuItem(
                          value: spol,
                          child: Text(spol),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'telefon',
                      decoration: InputDecoration(labelText: 'Telefon'),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'adresa',
                      decoration: InputDecoration(labelText: 'Adresa'),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderDateTimePicker(
                      name: 'datumZaposlenja',
                      inputType: InputType.date,
                      decoration:
                          InputDecoration(labelText: 'Datum zaposlenja'),
                      format: DateFormat("yyyy-MM-dd"),
                      initialDate: _selectedDate ?? DateTime.now(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDate = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'zvanje',
                      decoration: InputDecoration(labelText: 'Zvanje'),
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderField(
                      name: 'slika',
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Odaberite sliku',
                            errorText: field.errorText,
                          ),
                          child: ListTile(
                            leading: Icon(Icons.photo),
                            title: Text("Select image"),
                            trailing: Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _dodajTrenera();
              },
              child: Text('Spremi'),
            ),
          ],
          contentPadding: EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }

  String formatDateForJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  void _dodajTrenera() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var request = Map.from(_formKey.currentState!.value);
      request['datumZaposlenja'] = formatDateForJson(request['datumZaposlenja']);
       request['slika'] = _base64Image;
      _treneriProvider.insert(request);
      print(request);
    }
  }
}
