import 'package:fittofit_mobile/models/sale.dart';
import 'package:fittofit_mobile/models/termini.dart';
import 'package:fittofit_mobile/models/treneri.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/providers/sale_provider.dart';
import 'package:fittofit_mobile/providers/termini_provider.dart';
import 'package:fittofit_mobile/providers/treneri_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_provider.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RasporedPage extends StatefulWidget {
  const RasporedPage({Key? key}) : super(key: key);

  @override
  State<RasporedPage> createState() => _RasporedPageState();
}

class _RasporedPageState extends State<RasporedPage> {
  late TerminiProvider _terminiProvider;
  late TreninziProvider _treninziProvider;
  late TreneriProvider _treneriProvider;
  late SaleProvider _saleProvider;
  List<Termini> _list = [];
  List<Treninzi> _treninziList = [];
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _terminiProvider = context.read<TerminiProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    _saleProvider = context.read<SaleProvider>();
    _loadData();
  }

  void _loadData() async {
    var treninzi = await _treninziProvider.get();
    var raspored = await _terminiProvider.get();

    setState(() {
      _treninziList = treninzi.result;
      _list = raspored.result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<Treneri?> getTrenera(int trenerId) async {
    final trener = await _treneriProvider.getById(trenerId);
    return trener;
  }

  Future<Treninzi?> getTrening(int treningId) async {
    final trening = await _treninziProvider.getById(treningId);
    return trening;
  }

  Future<Sale?> getSalu(int salaId) async {
    final sala = await _saleProvider.getById(salaId);
    return sala;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Raspored'),
          backgroundColor: Colors.deepPurple.shade300,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _treninziList.map((trening) {
                    bool isSelected = trening.naziv == _selectedType;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _selectedType = isSelected ? null : trening.naziv;
                          });
                          var data = await _terminiProvider
                              .get(filter: {'nazivTreninga': _selectedType});
                          setState(() {
                            _list = data.result;
                          });
                        },
                        style: ButtonStyle(
                          textStyle:
                              MaterialStateProperty.resolveWith<TextStyle>(
                            (states) {
                              if (isSelected) {
                                return const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: 18);
                              } else {
                                return const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16);
                              }
                            },
                          ),
                        ),
                        child: Text(trening.naziv),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  final item = _list[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.blueAccent.shade100,
                        width: 3.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Termin: ${item.dan} u ${item.sat}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4.0),
                          FutureBuilder<Treninzi?>(
                            future: getTrening(item.treningId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final trening = snapshot.data;
                                if (trening != null) {
                                  return Text('Trening: ${trening.naziv}');
                                } else {
                                  return const Text("Nepoznato");
                                }
                              } else {
                                return const Text("Učitavanje treninga...");
                              }
                            },
                          ),
                          const SizedBox(height: 4.0),
                          FutureBuilder<Treneri?>(
                            future: getTrenera(item.trenerId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final trener = snapshot.data;
                                if (trener != null) {
                                  return Text(
                                      'Trener: ${trener.ime} ${trener.prezime}');
                                } else {
                                  return const Text("Nepoznato");
                                }
                              } else {
                                return const Text("Učitavanje trenera...");
                              }
                            },
                          ),
                          const SizedBox(height: 4.0),
                          FutureBuilder<Sale?>(
                            future: getSalu(item.salaId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final sala = snapshot.data;
                                if (sala != null) {
                                  return Text('Sala: ${sala.naziv}');
                                } else {
                                  return const Text("Nepoznato");
                                }
                              } else {
                                return const Text("Učitavanje sale...");
                              }
                            },
                          ),
                          if (item.brojClanova != null) ...[
                            const SizedBox(height: 4.0),
                            Text('Broj članova: ${item.brojClanova}'),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
