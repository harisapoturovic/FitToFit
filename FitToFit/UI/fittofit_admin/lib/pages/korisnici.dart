import 'dart:convert';
import 'dart:io';

import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/search_result.dart';
import 'package:fittofit_admin/pages/treneri_detalji.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
import '../widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';

import 'korisnici_detalji.dart';

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
  final ScrollController _userListController = ScrollController();
  final ScrollController _trainerListController = ScrollController();
  final TextEditingController _imeKorisnikaController = TextEditingController();
  final TextEditingController _prezimeKorisnikaController =
      TextEditingController();
  final TextEditingController _imeTreneraController = TextEditingController();
  final TextEditingController _prezimeTreneraController =
      TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime? datum;
  String? _dateErrorMessage;
  FocusNode _imeFocusNode = FocusNode();
  String? _selectedSpol;
  List<String> spolovi = [];

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    initForm();
    _loadData();
    _treneriProvider.addListener(() {
      _reloadTreneriList();
    });
    _korisniciProvider.addListener(() {
      _reloadKorisniciList();
    });
    _imeFocusNode = FocusNode();
    _dateErrorMessage = "Datum zaposlenja je obavezan.";
  }

  void _reloadTreneriList() async {
    var treneri = await _treneriProvider.get(filter: {});
    if (mounted) {
      setState(() {
        treneriResult = treneri;
      });
    }
  }

  void _reloadKorisniciList() async {
    var korisnici = await _korisniciProvider.get(filter: {'isKorisnik': true});
    if (mounted) {
      setState(() {
        korisniciResult = korisnici;
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
    var data1 = await _treneriProvider.get(filter: {});
    var data2 = await _korisniciProvider.get(filter: {'isKorisnik': true});
    spolovi = ['Muški', 'Ženski'];
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
      title: "Korisnici & treneri",
      selectedIndex: 1,
      showBackArrow: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTrainerDialog();
        },
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 130.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _imeKorisnikaController,
                          decoration: const InputDecoration(
                            hintText: 'Ime',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _ucitajKorisnike();
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _prezimeKorisnikaController,
                          decoration: const InputDecoration(
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
                const SizedBox(height: 20.0),
                Expanded(
                  child: userList(),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 130.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _imeTreneraController,
                          decoration: const InputDecoration(
                            hintText: 'Ime',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _ucitajTrenere();
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _prezimeTreneraController,
                          decoration: const InputDecoration(
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
                const SizedBox(height: 20.0),
                Expanded(
                  child: trainerList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userList() {
    List<Korisnici> korisnici = korisniciResult?.result ?? [];

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(242, 245, 251, 1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(
          left: 130.0, right: 130.0, top: 50.0, bottom: 50.0),
      padding: const EdgeInsets.all(50.0),
      child: Scrollbar(
        controller: _userListController,
        child: ListView.builder(
          controller: _userListController,
          itemCount: korisnici.length,
          itemBuilder: (context, index) {
            Korisnici korisnik = korisnici[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KorisniciDetaljiPage(
                      korisnik: korisnik,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 50.0),
                  leading: const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 116, 116, 116),
                    size: 30.0,
                  ),
                  title: Text(
                    '${korisnik.ime} ${korisnik.prezime}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Color.fromRGBO(0, 135, 202, 1),
                    ),
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
          color: const Color.fromRGBO(242, 245, 251, 1),
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.only(
            left: 130.0, right: 130.0, top: 50.0, bottom: 50.0),
        padding: const EdgeInsets.all(50.0),
        child: Scrollbar(
          controller: _trainerListController,
          child: ListView.builder(
            controller: _trainerListController,
            itemCount: treneri.length,
            itemBuilder: (context, index) {
              Treneri trener = treneri[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TreneriDetaljiPage(
                        trener: trener,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    leading: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 116, 116, 116),
                      size: 30.0,
                    ),
                    title: Text(
                      '${trener.ime} ${trener.prezime}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color.fromRGBO(0, 135, 202, 1),
                      ),
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
    _imeFocusNode.dispose();
    _userListController.dispose();
    _trainerListController.dispose();
    super.dispose();
  }

  void _ucitajKorisnike() async {
    var data = await _korisniciProvider.get(filter: {
      'ime': _imeKorisnikaController.text,
      'prezime': _prezimeKorisnikaController.text,
      'isKorisnik': true
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_imeFocusNode);
        });
        return AlertDialog(
          title: const Text('Dodaj novog trenera'),
          content: Container(
            width: 500.0,
            height: 900.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'ime',
                      focusNode: _imeFocusNode,
                      decoration: const InputDecoration(labelText: 'Ime'),
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
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'prezime',
                      decoration: const InputDecoration(labelText: 'Prezime'),
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
                    const SizedBox(height: 10.0),
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
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'telefon',
                      decoration: const InputDecoration(labelText: 'Telefon'),
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
                      },
                    ),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'Email'),
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
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'adresa',
                      decoration: const InputDecoration(labelText: 'Adresa'),
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
                    const SizedBox(height: 10.0),
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
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 10)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );

                        if (date == null) {
                          setState(() {
                            datum = null;
                            _dateErrorMessage = "Datum zaposlenja je obavezan.";
                          });
                        } else {
                          setState(() {
                            datum = date;
                            _dateErrorMessage = null;
                          });
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Izaberite datum zaposlenja",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_dateErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _dateErrorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    datum != null
                        ? Text(
                            "Izabrani datum zaposlenja: ${datum?.day}.${datum?.month}.${datum?.year}.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10.0),
                    FormBuilderTextField(
                      name: 'zvanje',
                      decoration: const InputDecoration(labelText: 'Zvanje'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (value.isNotEmpty &&
                              !RegExp(r'^[A-Z-ŠĐČĆŽ]').hasMatch(value)) {
                            return 'Zvanje mora početi velikim slovom.';
                          } else if (value.length < 3) {
                            return 'Morate unijeti najmanje 3 karaktera.';
                          } else if (value.length > 100) {
                            return 'Premašili ste maksimalan broj karaktera (100).';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
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
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _dodajTrenera();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              child: const Text('Spremi'),
            ),
          ],
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }

  void _dodajTrenera() {
    late String datumVrijeme;
    if (datum == null) {
      setState(() {
        _dateErrorMessage = "Datum zaposlenja je obavezan.";
      });
      return;
    }

    _formKey.currentState?.saveAndValidate();
    if (_formKey.currentState!.validate()) {
      String datum_ = datum.toString();
      datumVrijeme =
          DateTime.parse(datum_.replaceAll(' ', 'T')).toIso8601String();
      var request = Map.from(_formKey.currentState!.value);
      request['slika'] = _base64Image;
      request.addAll({
        'datumZaposlenja': datumVrijeme,
      });

      try {
        _treneriProvider.insert(request);
        if (mounted) {
          setState(() {
            _formKey.currentState?.reset();
            _selectedSpol = null;
            datum = null;
            spolovi = [];
            _image = null;
            _base64Image = null;
            _dateErrorMessage = "Datum zaposlenja je obavezan.";
            spolovi = ['Muški', 'Ženski'];
          });
        }
        _showAlertDialog(
            "Uspješan unos", "Trener uspješno dodat.", Colors.green);
      } on Exception catch (e) {
        _showAlertDialog("Greška", e.toString(), Colors.red);
      }
    } else {
      setState(() {
        if (datum == null) {
          _dateErrorMessage = "Datum zaposlenja je obavezan.";
        }
      });
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
}
