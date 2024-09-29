import 'package:fittofit_admin/models/akcije.dart';
import 'package:fittofit_admin/models/akcijeTreninzi.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/providers/akcije_provider.dart';
import 'package:fittofit_admin/providers/akcije_treninzi_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  String? _dateErrorMessage1;
  String? _dateErrorMessage2;

  @override
  void initState() {
    super.initState();

    _treninziProvider = context.read<TreninziProvider>();
    _akcijeTreninziProvider = context.read<AkcijeTreninziProvider>();
    _akcijeProvider = context.read<AkcijeProvider>();
    _pocetakAkcije = widget.akcija.datumPocetka;
    _zavrsetakAkcije = widget.akcija.datumZavrsetka;
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
                          itemCount: widget.akcija.akcijeTreninzis?.length,
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
                              child: const Row(
                                children: [
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
                              child: const Row(
                                children: [
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
                                  child: const Row(
                                    children: [
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
                                  child: const Row(
                                    children: [
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
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
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
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
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
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
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

  void _reloadAkcijeTreninzis() async {
    try {
      var updatedAkcijeTreninzis = await _fetchUpdatedAkcijeTreninzis();
      setState(() {
        widget.akcija.akcijeTreninzis = updatedAkcijeTreninzis;
      });
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  Future<List<AkcijeTreninzi>> _fetchUpdatedAkcijeTreninzis() async {
    var result = await _akcijeTreninziProvider.get(filter: {
      'akcijaId': widget.akcija.akcijaId,
    });
    for (var akcijaTrening in result.result) {
      akcijaTrening.trening =
          await _treninziProvider.getById(akcijaTrening.treningId);
    }
    return result.result;
  }

  void _dodajTreningNaAkciju() async {
    _formKey.currentState?.saveAndValidate();
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
      _reloadAkcijeTreninzis();
    } on Exception catch (e) {
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
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
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
        _reloadAkcijeTreninzis();
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
      _loadData();
    } catch (e) {
      _showAlertDialog("Greška", e.toString(), Colors.red);
    }
  }

  void _aktivirajAkciju() async {
    try {
      await _akcijeProvider.activate(widget.akcija.akcijaId);
      _showAlertDialog(
          "Uspješno aktiviranje", "Akcija uspješno aktivirana.", Colors.green);
      _loadData();
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
                    child: SizedBox(
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
                                              } else if (!RegExp(
                                                      r'^[A-Z-ŠĐČĆŽ]')
                                                  .hasMatch(value)) {
                                                return 'Naziv mora početi velikim slovom.';
                                              } else if (value.length < 5) {
                                                return 'Morate unijeti najmanje 5 karaktera.';
                                              } else if (value.length > 50) {
                                                return 'Premašili ste maksimalan broj karaktera (50).';
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
                                              } else if (!RegExp(r'^[0-9]+$')
                                                  .hasMatch(value)) {
                                                return 'Ovo polje može sadržavati samo brojeve.';
                                              } else {
                                                final broj =
                                                    int.tryParse(value) ?? 0;
                                                if (broj < 1 || broj > 99) {
                                                  return 'Dozvoljen je unos brojeva između 1 i 99.';
                                                }
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 24),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 208, 207, 207),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            ),
                                            onPressed: () async {
                                              final DateTime? date =
                                                  await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                lastDate:
                                                    DateTime.utc(2024, 12, 31),
                                              );
                                              if (date == null) {
                                                setState(() {
                                                  _pocetakAkcije = null;
                                                  _dateErrorMessage1 =
                                                      "Datum početka akcije je obavezan.";
                                                });
                                              } else {
                                                setState(() {
                                                  _pocetakAkcije = date;
                                                  _dateErrorMessage1 = null;
                                                });
                                              }
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Izaberite datum početka akcije",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_dateErrorMessage1 != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                _dateErrorMessage1!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          _pocetakAkcije != null
                                              ? Text(
                                                  "Izabrani datum početka: ${_pocetakAkcije?.day}.${_pocetakAkcije?.month}.${_pocetakAkcije?.year}.",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Container(),
                                          const SizedBox(height: 10.0),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 24),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 208, 207, 207),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            ),
                                            onPressed: () async {
                                              final DateTime? date =
                                                  await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                lastDate:
                                                    DateTime.utc(2024, 12, 31),
                                              );
                                              if (date == null) {
                                                setState(() {
                                                  _zavrsetakAkcije = null;
                                                  _dateErrorMessage2 =
                                                      "Datum završetka akcije je obavezan.";
                                                });
                                              } else {
                                                setState(() {
                                                  _zavrsetakAkcije = date;
                                                  _dateErrorMessage2 = null;
                                                });
                                              }
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Izaberite datum završetka akcije",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_dateErrorMessage2 != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                _dateErrorMessage2!,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          _zavrsetakAkcije != null
                                              ? Text(
                                                  "Izabrani datum završetka: ${_zavrsetakAkcije?.day}.${_zavrsetakAkcije?.month}.${_zavrsetakAkcije?.year}.",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Container(),
                                          const SizedBox(height: 32),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_pocetakAkcije == null) {
                                                setState(() {
                                                  _dateErrorMessage1 =
                                                      "Datum početka akcije je obavezan.";
                                                });
                                                return;
                                              }
                                              if (_zavrsetakAkcije == null) {
                                                setState(() {
                                                  _dateErrorMessage2 =
                                                      "Datum završetka akcije je obavezan.";
                                                });
                                                return;
                                              }

                                              if (_pocetakAkcije!
                                                  .isAfter(_zavrsetakAkcije!)) {
                                                setState(() {
                                                  _dateErrorMessage1 =
                                                      "Datum početka akcije ne može biti poslije datuma završetka akcije.";
                                                  _dateErrorMessage2 =
                                                      "Datum početka akcije ne može biti poslije datuma završetka akcije.";
                                                });
                                                return;
                                              }
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
                                                setState(() {
                                                  _formKey.currentState
                                                      ?.reset();
                                                  _dateErrorMessage1 = null;
                                                  _dateErrorMessage2 = null;
                                                });
                                                _showAlertDialog(
                                                    "Uspješan edit",
                                                    "Podaci o akciji uspješno ažurirani.",
                                                    Colors.green);
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
