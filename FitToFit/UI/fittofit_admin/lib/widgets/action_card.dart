import 'package:fittofit_admin/models/akcije.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/providers/akcije_provider.dart';
import 'package:fittofit_admin/providers/akcije_treninzi_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AkcijeCard extends StatefulWidget {
  final Akcije akcija;

  const AkcijeCard({Key? key, required this.akcija}) : super(key: key);
  @override
  State<AkcijeCard> createState() => _AkcijeCardState();
}

class _AkcijeCardState extends State<AkcijeCard> {
  late TreninziProvider _treninziProvider;
  late AkcijeProvider _akcijeProvider;
  late AkcijeTreninziProvider _akcijeTreninziProvider;
  List<Treninzi> _treninziList = [];
  DateTime? _pocetakAkcije;
  DateTime? _zavrsetakAkcije;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    _treninziProvider = context.read<TreninziProvider>();
    _akcijeTreninziProvider = context.read<AkcijeTreninziProvider>();
    _akcijeProvider = context.read<AkcijeProvider>();
    _loadData();
  }

  void _loadData() async {
    try {
      var treninzi = await _treninziProvider.get();

      if (mounted) {
        setState(() {
          _treninziList = treninzi.result;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRect(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Container(
                      width: 250.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                            width: 130.0,
                            height: 130.0,
                            child: Image.asset(
                              widget.akcija.stateMachine == 'active'
                                  ? 'assets/images/activeAction.png'
                                  : widget.akcija.stateMachine == 'archived'
                                      ? 'assets/images/archivedAction.png'
                                      : 'assets/images/draftAction.png',
                              fit: BoxFit.cover,
                            )),
                      ))),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.akcija.naziv.length > 20
                      ? '${widget.akcija.naziv.substring(0, 20)}...'
                      : widget.akcija.naziv,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 90, 90, 90)),
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatDate(widget.akcija.datumPocetka)} - ${formatDate(widget.akcija.datumZavrsetka)}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalji - ${widget.akcija.naziv}'),
          content: Container(
            width: 350.0,
            height: 400.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 30),
            child: SingleChildScrollView(
                child: Card(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Treninzi koji su na akciji:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 103, 103, 103),
                      ),
                    ),
                  ),
                  const Divider(),
                  widget.akcija.akcijeTreninzis?.length != 0
                      ? ListView.builder(
                          itemCount: widget.akcija.akcijeTreninzis?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                '- ${widget.akcija.akcijeTreninzis?[index].trening?.naziv ?? 'empty'}',
                                style: const TextStyle(),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  try {
                                    _confirmDeleteTraining(
                                        context,
                                        widget.akcija.akcijeTreninzis?[index]
                                            .akcijaTreningId);
                                  } on Exception catch (e) {
                                    _showAlertDialog(
                                        "Greška", e.toString(), Colors.red);
                                  }
                                },
                                child: const Icon(Icons.delete),
                              ),
                            );
                          },
                        )
                      : const Text("Nema treninga na akciji!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 86, 86, 86),
                          )),
                  const SizedBox(
                    height: 50,
                  ),
                  widget.akcija.stateMachine == 'active'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _dodajTrening(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: MaterialStateProperty.all<double>(0),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 96, 96, 96)),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize:
                                    MaterialStateProperty.all<Size>(Size.zero),
                              ),
                              child: Row(
                                children: const [
                                  Text('Dodaj trening na akciju'),
                                  SizedBox(width: 5),
                                  Icon(Icons.add)
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _confirmArchiveAction(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: MaterialStateProperty.all<double>(0),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 96, 96, 96)),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize:
                                    MaterialStateProperty.all<Size>(Size.zero),
                              ),
                              child: Row(
                                children: const [
                                  Text('Arhiviraj akciju'),
                                  SizedBox(width: 5),
                                  Icon(Icons.history)
                                ],
                              ),
                            ),
                          ],
                        )
                      : widget.akcija.stateMachine == 'draft'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _dodajTrening(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    foregroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromARGB(255, 96, 96, 96)),
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.zero),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size.zero),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text('Dodaj trening na akciju'),
                                      SizedBox(width: 5),
                                      Icon(Icons.add)
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _confirmActivateAction(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    foregroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromARGB(255, 96, 96, 96)),
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.zero),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size.zero),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text('Aktiviraj akciju'),
                                      SizedBox(width: 5),
                                      Icon(Icons.open_in_new)
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                  const SizedBox(height: 30),
                  widget.akcija.stateMachine == 'draft'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _urediAkciju();
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
                              child: const Text('Uredi akciju'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _confirmDeleteAction(context);
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
                              child: const Text('Obriši akciju'),
                            ),
                          ],
                        )
                      : widget.akcija.stateMachine == 'archived'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _confirmDeleteAction(context);
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
                                  child: const Text('Obriši akciju'),
                                ),
                              ],
                            )
                          : Container(),
                ],
              ),
            )),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
        );
      },
    );
  }

  void _dodajTrening(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novi trening na akciji'),
          content: Container(
            width: 350.0,
            height: 200.0,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: SingleChildScrollView(
                child: Card(
              margin: const EdgeInsets.all(10.0),
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      name: 'treningId',
                      decoration: const InputDecoration(labelText: 'Treninzi'),
                      initialValue: _treninziList[0].treningId,
                      items: _treninziList.map((trening) {
                        return DropdownMenuItem(
                          value: trening.treningId,
                          child: Text(trening.naziv),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            )),
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
                _dodajTreningNaAkciju();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0, 154, 231, 1),
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

  void _dodajTreningNaAkciju() async {
    _formKey.currentState?.saveAndValidate();
    final currentFormState = _formKey.currentState;
    if (!_areAllFieldsFilled(currentFormState)) {
      _showAlertDialog(
          "Upozorenje", "Popunite sva obavezna polja.", Colors.orange);
      return;
    }
    if (currentFormState != null) {
      if (!currentFormState.validate()) {
        _showAlertDialog(
            "Upozorenje",
            "Molimo vas da ispravno popunite sva obavezna polja.",
            Colors.orange);
        return;
      }
    }

    var request = Map.from(_formKey.currentState!.value);
    request['akcijaId'] = widget.akcija.akcijaId;

    if (widget.akcija.akcijeTreninzis != null) {
      for (var at in widget.akcija.akcijeTreninzis!) {
        if (request['treningId'] == at.treningId) {
          _showAlertDialog("Upozorenje", "Odabrani trening je već na akciji.",
              Colors.orange);
          return;
        }
      }
    }
    try {
      await _akcijeTreninziProvider.insert(request);
      _showAlertDialog(
          "Uspješan unos",
          "Trening uspješno dodat na akciju ${widget.akcija.naziv}.",
          Colors.green);
    } on Exception catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) {
      return false;
    }

    List<String> requiredFields = ['treningId'];

    for (String fieldName in requiredFields) {
      if (formState.fields[fieldName]?.value == null ||
          formState.fields[fieldName]!.value.toString().isEmpty) {
        return false;
      }
    }

    return true;
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

  void _confirmDeleteTraining(BuildContext context, int? akcijaTreningId) {
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
              'Da li ste sigurni da želite ukloniti trening sa akcije?'),
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
                _ukloniTrening(akcijaTreningId);
                Navigator.pop(context);
              },
              child: const Text(
                'Ukoni',
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

  void _confirmDeleteAction(BuildContext context) {
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
              const Text('Da li ste sigurni da želite izbrisati ovu akciju?'),
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
                _obrisiAkciju();
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

  void _confirmArchiveAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda arhiviranja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text('Da li ste sigurni da želite arhivirati akciju?'),
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
                _arhivirajAkciju();
                Navigator.pop(context);
              },
              child: const Text(
                'Arhiviraj',
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

  void _confirmActivateAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 247, 255),
          title: const Text(
            'Potvrda aktiviranja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text('Da li ste sigurni da želite aktivirati akciju?'),
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
                _aktivirajAkciju();
                Navigator.pop(context);
              },
              child: const Text(
                'Aktiviraj',
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

  void _ukloniTrening(int? akcijaTreningId) async {
    try {
      if (akcijaTreningId != null) {
        await _akcijeTreninziProvider.delete(akcijaTreningId);
        _showAlertDialog("Uspješno brisanje",
            "Trening uspješno uklonjen sa akcije.", Colors.green);
      }
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _arhivirajAkciju() async {
    try {
      await _akcijeProvider.archive(widget.akcija.akcijaId);
      _showAlertDialog(
          "Uspješno arhiviranje", "Akcija uspješno arhvirana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _aktivirajAkciju() async {
    try {
      await _akcijeProvider.activate(widget.akcija.akcijaId);
      _showAlertDialog(
          "Uspješno aktiviranje", "Akcija uspješno aktivirana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  _urediAkciju() async {
    var odabranaAkcija = widget.akcija;
    final TextEditingController nazivController =
        TextEditingController(text: odabranaAkcija.naziv);
    final TextEditingController iznosController =
        TextEditingController(text: odabranaAkcija.iznos.toString());

    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj akciju'),
                content: SingleChildScrollView(
                    child: Container(
                  height: 500,
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

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderTextField(
                                            name: 'iznos',
                                            controller: iznosController,
                                            decoration: const InputDecoration(
                                              labelText: 'Iznos',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ovo polje je obavezno!';
                                              }
                                              if (!RegExp(r'^[0-9]+$')
                                                  .hasMatch(value)) {
                                                return 'Ovo polje može sadržavati samo brojeve.';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderDateTimePicker(
                                            name: 'datumPocetka',
                                            inputType: InputType.date,
                                            decoration: const InputDecoration(
                                                labelText: 'Datum početka'),
                                            format: DateFormat("yyyy-MM-dd"),
                                            initialDate:
                                                odabranaAkcija.datumPocetka,
                                            onChanged: (value) {
                                              setState(() {
                                                _pocetakAkcije = value;
                                              });
                                            },
                                            validator:
                                                FormBuilderValidators.compose([
                                              (value) {
                                                if (value == null) {
                                                  return 'Ovo polje je obavezno!';
                                                }
                                                return null;
                                              },
                                            ]),
                                          ),
                                          const SizedBox(height: 16),
                                          FormBuilderDateTimePicker(
                                            name: 'datumZavrsetka',
                                            inputType: InputType.date,
                                            decoration: const InputDecoration(
                                                labelText: 'Datum završetka'),
                                            format: DateFormat("yyyy-MM-dd"),
                                            initialDate:
                                                odabranaAkcija.datumZavrsetka,
                                            onChanged: (value) {
                                              setState(() {
                                                _zavrsetakAkcije = value;
                                              });
                                            },
                                            validator:
                                                FormBuilderValidators.compose([
                                              (value) {
                                                if (value == null) {
                                                  return 'Ovo polje je obavezno!';
                                                }
                                                return null;
                                              },
                                            ]),
                                          ),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                Akcije akcija = Akcije(
                                                    akcijaId:
                                                        odabranaAkcija.akcijaId,
                                                    naziv: nazivController.text,
                                                    iznos: int.tryParse(
                                                            iznosController
                                                                .text) ??
                                                        0,
                                                    datumPocetka:
                                                        _pocetakAkcije ??
                                                            odabranaAkcija
                                                                .datumPocetka,
                                                    datumZavrsetka:
                                                        _zavrsetakAkcije ??
                                                            odabranaAkcija
                                                                .datumZavrsetka);

                                                _akcijeProvider.update(
                                                    odabranaAkcija.akcijaId,
                                                    akcija);
                                                _showAlertDialog(
                                                    "Uspješan edit",
                                                    "Podaci o akciji uspješno ažurirani.",
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

  void _obrisiAkciju() async {
    try {
      await _akcijeProvider.delete(widget.akcija.akcijaId);
      _showAlertDialog(
          "Uspješno brisanje", "Akcija uspješno izbrisana.", Colors.green);
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }
}
