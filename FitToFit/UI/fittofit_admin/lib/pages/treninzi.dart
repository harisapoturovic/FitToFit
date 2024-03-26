import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:fittofit_admin/widgets/training_carousel.dart';
import 'package:fittofit_admin/widgets/tranining_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class TreninziPage extends StatefulWidget {
  const TreninziPage({Key? key}) : super(key: key);

  @override
  State<TreninziPage> createState() => _TreninziPageState();
}

class _TreninziPageState extends State<TreninziPage> {
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreninziProvider _treninziProvider;
  TextEditingController _nazivController = new TextEditingController();
  List<VrsteTreninga> _vrsteTreningaList = [];
  List<Treninzi> _treninziList = [];
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
  }

  void _loadData() async {
    var vrsteTreninga = await _vrsteTreningaProvider.get(filter: {});
    var treninzi = await _treninziProvider.get(filter: {});
    setState(() {
      _vrsteTreningaList = vrsteTreninga.result;
      _treninziList = treninzi.result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          Expanded(child: _searchWidgets()),
          SizedBox(height: 10),
          Expanded(
            child: _listOfTrainings(),
          ),
        ],
      ),
      title: "Treninzi",
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  Widget _searchWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 500.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Naziv treninga"),
                  controller: _nazivController,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  var data = await _treninziProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'vrstaTreninga': _selectedType
                  });

                  setState(() {
                    _treninziList = data.result;
                  });
                },
                child: Text("Pretraži"),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 520.0),
          child: Row(
            children: _vrsteTreningaList.map((vrsta) {
              bool isSelected = vrsta.naziv == _selectedType;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = isSelected ? null : vrsta.naziv;
                    });
                  },
                  style: ButtonStyle(
                    textStyle:
                        MaterialStateProperty.resolveWith<TextStyle>((states) {
                      if (isSelected) {
                        return TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                        );
                      } else {
                        return TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        );
                      }
                    }),
                  ),
                  child: Text(vrsta.naziv!),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _listOfTrainings() {
    ScrollController _scrollController = ScrollController();

    return Container(
      margin: EdgeInsets.only(bottom: 70, left: 50, right: 50, top: 0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 245, 248),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            children: _treninziList.map((training) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 225, 225, 225),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TrainingCard(training: training),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
