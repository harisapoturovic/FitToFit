import 'package:fittofit_admin/models/akcije.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/providers/akcije_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/widgets/action_card.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AkcijePage extends StatefulWidget {
  const AkcijePage({Key? key}) : super(key: key);

  @override
  State<AkcijePage> createState() => _AkcijePageState();
}

class _AkcijePageState extends State<AkcijePage> {
  late AkcijeProvider _akcijeProvider;
  late TreninziProvider _treninziProvider;
  TextEditingController _nazivController = new TextEditingController();
  List<Akcije> _aktivneAkcijeList = [];
  List<Akcije> _arhiviraneAkcijeList = [];
  List<Akcije> _draftAkcijeList = [];
  List<Akcije> _selectedAkcije = [];
  List<Treninzi> _treninziList = [];
  DateTime? _selectedDate;
  DateTime? _pocetakAkcije;
  DateTime? _zavrsetakAkcije;
  List<int> _selectedItems = [];
  List<String> nazivList = [];
  List<int>? items;
  bool isActive = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _akcijeProvider = context.read<AkcijeProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _loadData();
  }

  void _loadData() async {
    var aktivneAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "active"});

    var arhiviraneAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "archived"});

    var draftAkcije = await _akcijeProvider
        .get(filter: {'IsTreninziIncluded': true, 'StateMachine': "draft"});

    var treninzi = await _treninziProvider.get();

    setState(() {
      _aktivneAkcijeList = aktivneAkcije.result;
      _arhiviraneAkcijeList = arhiviraneAkcije.result;
      _draftAkcijeList = draftAkcije.result;
      _treninziList = treninzi.result;
      _selectedAkcije = _aktivneAkcijeList;
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _searchWidgets()),
          SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: _listOfActiveActions(),
          ),
          Expanded(
            flex: 4,
            child: _listOfArchivedActions(),
          ),
        ],
      ),
      title: "Akcije",
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  String formatDate(DateTime? dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime!);
  }

  Widget _searchWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Naziv akcije",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color.fromRGBO(0, 154, 231, 1),
                  ),
                ),
              ),
              controller: _nazivController,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: FormBuilderDateTimePicker(
                  name: 'datumPocetka',
                  inputType: InputType.date,
                  decoration: const InputDecoration(labelText: 'Datum početka'),
                  format: DateFormat("yyyy-MM-dd"),
                  initialDate: _selectedDate ?? DateTime.now(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDate = value;
                    });
                  }),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 130),
              child: ElevatedButton(
                onPressed: () async {
                  var data1 = await _akcijeProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'datumPocetka': _selectedDate,
                    'stateMachine': "active"
                  });

                  var data2 = await _akcijeProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'datumPocetka': _selectedDate,
                    'stateMachine': "archived"
                  });

                  var data3 = await _akcijeProvider.get(filter: {
                    'naziv': _nazivController.text,
                    'datumPocetka': _selectedDate,
                    'stateMachine': "draft"
                  });

                  setState(() {
                    _aktivneAkcijeList = data1.result;
                    _arhiviraneAkcijeList = data2.result;
                    _draftAkcijeList = data3.result;
                    if (isActive) {
                      _selectedAkcije = _aktivneAkcijeList;
                    } else {
                      _selectedAkcije = _draftAkcijeList;
                    }
                  });
                },
                child: Text("Pretraži"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(0, 154, 231, 1),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                  side: BorderSide(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listOfActiveActions() {
    ScrollController _scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isActive = true;
                    _selectedAkcije = _aktivneAkcijeList;
                  });
                },
                child: Text(
                  'Aktivne akcije',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Color.fromARGB(255, 46, 142, 50)
                          : Colors.grey),
                ),
              ),
              SizedBox(width: 10),
              Text('/'),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isActive = false;
                    _selectedAkcije = _draftAkcijeList;
                  });
                },
                child: Text(
                  'Draft akcije',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.grey : Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: _selectedAkcije.map((akcija) {
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
                          child: AkcijeCard(akcija: akcija),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listOfArchivedActions() {
    ScrollController _scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Arhiva',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 94, 94)),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: _arhiviraneAkcijeList.map((akcija) {
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
                          child: AkcijeCard(akcija: akcija)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
