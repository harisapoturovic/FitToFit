import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/models/vrste_treninga.dart';
import 'package:fittofit_mobile/pages/treninzi_detalji.dart';
import 'package:fittofit_mobile/providers/treninzi_provider.dart';
import 'package:fittofit_mobile/providers/vrste_treninga_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  final int selectedIndex;
  const TrainingPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreninziProvider _treninziProvider;
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  String? _selectedType;
  String? _selectedNamjena;
  bool isSearching = false;
  final TextEditingController _nazivController = TextEditingController();
  List<String> namjena = [
    'Mršavljenje',
    'Izgradnja mišića',
    'Kondicija',
    'Fleksibilnost i mobilnost',
    'Rehabilitacija i oporavak'
  ];

  @override
  void initState() {
    super.initState();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    isSearching = false;
    var vrsteTreninga =
        await _vrsteTreningaProvider.get(filter: {'isTerminiIncluded': false});

    var treninzi =
        await _treninziProvider.get(filter: {'isVjezbeIncluded': true});
    if (mounted) {
      setState(() {
        _vrsteTreningaList = vrsteTreninga.result;
        _treninziList = treninzi.result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Treninzi'),
            backgroundColor: Colors.deepPurple.shade300,
            foregroundColor: Colors.white,
            leading: Container(),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: _vrsteTreningaList.map((vrsta) {
                    bool isSelected = vrsta.naziv == _selectedType;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _selectedType = isSelected ? null : vrsta.naziv;
                          });
                          _getFilteredTrainings();
                        },
                        style: ButtonStyle(
                          textStyle:
                              WidgetStateProperty.resolveWith<TextStyle>(
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
                        child: Text(vrsta.naziv!),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Naziv treninga',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                    ),
                    controller: _nazivController,
                    onChanged: (value) {
                      _getFilteredTrainings();
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: namjena.map((n) {
                        bool isSelected = n == _selectedNamjena;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                _selectedNamjena = isSelected ? null : n;
                              });
                              _getFilteredTrainings();
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.blue.shade300),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                              textStyle:
                                  WidgetStateProperty.resolveWith<TextStyle>(
                                (states) {
                                  if (isSelected) {
                                    return const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18);
                                  } else {
                                    return const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16);
                                  }
                                },
                              ),
                            ),
                            child: Text(n),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _treninziList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildTrainingBlock(_treninziList[index]);
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildTrainingBlock(Treninzi treninzi) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TreninziDetaljiPage(trening: treninzi),
          ),
        );
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRect(
            child: treninzi.slika != null && treninzi.slika != ''
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      width: 300.0,
                      height: 250.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: imageFromBase64String(treninzi.slika!).image,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                        width: 300.0,
                        height: 250.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/images/training.jpg',
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              treninzi.naziv,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getFilteredTrainings() async {
    isSearching = true;
    var data = await _treninziProvider.get(filter: {
      'naziv': _nazivController.text,
      'vrstaTreningaNaziv': _selectedType,
      'namjena': _selectedNamjena,
      'isVjezbeIncluded': true
    });

    setState(() {
      _treninziList = data.result;
    });
  }
}
