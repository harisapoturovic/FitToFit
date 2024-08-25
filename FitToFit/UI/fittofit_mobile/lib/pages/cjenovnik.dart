import 'package:fittofit_mobile/models/clanarine.dart';
import 'package:fittofit_mobile/models/treninziClanarine.dart';
import 'package:fittofit_mobile/models/vrste_treninga.dart';
import 'package:fittofit_mobile/providers/clanarine_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_clanarine_provider.dart';
import 'package:fittofit_mobile/providers/vrste_treninga_provider.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CjenovnikPage extends StatefulWidget {
  const CjenovnikPage({Key? key}) : super(key: key);

  @override
  State<CjenovnikPage> createState() => _CjenovnikPageState();
}

class _CjenovnikPageState extends State<CjenovnikPage> {
  late TreninziClanarineProvider _treninziClanarineProvider;
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late ClanarineProvider _clanarineProvider;
  List<TreninziClanarine> _list = [];
  List<VrsteTreninga> _vrsteTreningaList = [];
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _treninziClanarineProvider = context.read<TreninziClanarineProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _clanarineProvider = context.read<ClanarineProvider>();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    var vrsteTreninga =
        await _vrsteTreningaProvider.get(filter: {'IsTerminiIncluded': false});
    var cjenovnik = await _treninziClanarineProvider.get();

    setState(() {
      _vrsteTreningaList = vrsteTreninga.result;
      _list = cjenovnik.result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<Clanarine?> getClanarinu(int clanarinaId) async {
    final clanarina = await _clanarineProvider.getById(clanarinaId);
    return clanarina;
  }

  Future<VrsteTreninga?> getVrstuTreninga(int vrstaTreningaId) async {
    final vrstaTreninga = await _vrsteTreningaProvider.getById(vrstaTreningaId);
    return vrstaTreninga;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Cjenovnik'),
            backgroundColor: Colors.deepPurple.shade300,
            foregroundColor: Colors.white),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _vrsteTreningaList.map((vrsta) {
                    bool isSelected = vrsta.naziv == _selectedType;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _selectedType = isSelected ? null : vrsta.naziv;
                          });
                          var data = await _treninziClanarineProvider
                              .get(filter: {'vrstaTreningaNaziv': _selectedType});
                          setState(() {
                            _list = data.result;
                          });
                        },
                        style: ButtonStyle(
                          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
                            (states) {
                              if (isSelected) {
                                return const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: 18);
                              } else {
                                return const TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 16);
                              }
                            },
                          ),
                        ),
                        child: Text(vrsta.naziv!),
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
                          FutureBuilder<Clanarine?>(
                            future: getClanarinu(item.clanarinaId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final clanarina = snapshot.data;
                                if (clanarina != null) {
                                  return Text('Članarina: ${clanarina.naziv}');
                                } else {
                                  return const Text("Nepoznato");
                                }
                              } else {
                                return const Text("Učitavanje članarine...");
                              }
                            },
                          ),
                          const SizedBox(height: 4.0),
                          FutureBuilder<VrsteTreninga?>(
                            future: getVrstuTreninga(item.vrstaTreningaId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final vrstaTreninga = snapshot.data;
                                if (vrstaTreninga != null) {
                                  return Text(
                                      'Vrsta treninga: ${vrstaTreninga.naziv}');
                                } else {
                                  return const Text("Nepoznato");
                                }
                              } else {
                                return const Text(
                                    "Učitavanje vrste treninga...");
                              }
                            },
                          ),
                          if (item.ucestalost != null) ...[
                            const SizedBox(height: 4.0),
                            Text('Učestalost: ${item.ucestalost}x'),
                          ],
                          const SizedBox(height: 4.0),
                          Text('Cijena: ${item.cijena} KM')
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
