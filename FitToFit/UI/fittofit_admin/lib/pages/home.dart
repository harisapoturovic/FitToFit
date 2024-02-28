import 'dart:io';

import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/novosti.dart';
import 'package:fittofit_admin/models/search_result.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
import '../widgets/master_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NovostiProvider _novostiProvider;
  late KorisniciProvider _korisniciProvider;
  late VrsteTreningaProvider _vrsteTreningaProvider;
  late TreneriProvider _treneriProvider;
  SearchResult<Novosti>? result;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<VrsteTreninga>? vrsteTreningaResult;
  SearchResult<Treneri>? treneriResult;
  TextEditingController _naslovController = new TextEditingController();
  TextEditingController _vrstaTrController = new TextEditingController();
  TextEditingController _treneriController = new TextEditingController();
  List<VrsteTreninga> _vrsteTreningaList = [];
  String? _selectedVrstaTreninga;

  @override
  void initState() {
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    //korisniciResult = await _korisniciProvider.get();
    //print(korisniciResult);
    if (mounted) {
      vrsteTreningaResult = await _vrsteTreningaProvider.get();
      print("vrsteTreningaResult: $vrsteTreningaResult");

      // Example: Update the dropdown with vrsteTreningaResult after fetching data
      if (vrsteTreningaResult != null) {
        print("Result count: ${vrsteTreningaResult!.count}");

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            // Update the dropdown with vrsteTreningaResult
            _selectedVrstaTreninga = vrsteTreningaResult!.result.isNotEmpty
                ? vrsteTreningaResult!.result[0].naziv
                : null;
          });
          print("Dropdown updated: $_selectedVrstaTreninga");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [Dashboard()],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ),
          Expanded(
            child: Column(
              children: [_buildSearch(), _buildDataListView()],
            ),
          ),
        ],
      ),
      title: "Početna",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.only(top: 80, left: 30, right: 30),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: "Naslov"),
            controller: _naslovController,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: DropdownButtonFormField(
            decoration: InputDecoration(labelText: "Vrsta treninga"),
            value: _selectedVrstaTreninga,
            items: _vrsteTreningaList.map((VrsteTreninga vrsta) {
              return DropdownMenuItem(
                value: vrsta.naziv,
                child: Text(vrsta.naziv!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedVrstaTreninga = value as String?;
              });
            },
          ),
        ),
        SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () async {
            print("login proceed");
            //Navigator.of(context).pop();

            var data = await _novostiProvider.get(filter: {
              //dinamički objekat, umjesto da pravimo novu klasu kao što smo imali za proizvod
              'naslov': _naslovController.text,
              'vrstaTreningaId': _vrstaTrController.text
            });

            setState(() {
              result = data;
            });

            //print("data: ${data.result[0].naziv}");
          },
          child: Text("Pretraži"),
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(0, 154, 231, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            side: BorderSide(color: Colors.white),
          ),
        )
      ]),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            children: result?.result
                    .map((Novosti e) => Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 60.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.only(left: 20),
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.grey),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      '${e.naslov ?? ''}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(0, 154, 231, 1),
                                      ),
                                    ),
                                    Text('   |   '),
                                    Text(
                                      '${formatDate(e.datumObjave)}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color.fromRGBO(0, 154, 231, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(
                                      '${e.sadrzaj != null && e.sadrzaj!.length > 80 ? e.sadrzaj!.substring(0, 80) + '...' : e.sadrzaj ?? ''}',
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  margin: EdgeInsets.only(right: 30.0),
                                  child: Text(
                                    '>',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: Color.fromRGBO(0, 154, 231, 1),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Handle the tap event
                                  /*
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(product: e),
                              ),
                          );
                          */
                                },
                              ),
                            ),
                            SizedBox(height: 8.0)
                          ],
                        ))
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime? dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime!);
  }

  Dashboard() {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 40),
            child: Text(
              "Dashboard",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: "ProtestRevoulution",
                  color: Colors.black54.withBlue(70)),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First block
              Container(
                margin: EdgeInsets.only(right: 8),
                width: MediaQuery.of(context).size.width * 0.22,
                height: 200,
                child: DashboardBlock(
                    color: Color.fromARGB(255, 160, 203, 255),
                    title: 'BROJ KORISNIKA',
                    content: '80'),
              ),
              // Second block
              Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  height: 200,
                  child: DashboardBlock(
                      color: Color.fromARGB(255, 242, 239, 152),
                      title: 'BROJ TRENERA',
                      content: "2")),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Third block
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 140,
                  child: DashboardBlock(
                      color: Color.fromARGB(255, 248, 166, 133),
                      title: 'TRENUTNO AKTIVNIH REZERVACIJA',
                      content: '32'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // pokusaj sredjivanja novosti
  /*Expanded(
      child: Scrollbar(
        child: ListView(
          restorationId: 'novosti',
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            
            for (int index = 1; index < result.count!; index++)
              ListTile(
                leading: ExcludeSemantics(
                  child: CircleAvatar(child: Text('$index')),
                ),
                title: Text(result?.result.map((Novosti e) => e.naslov.toString())),
                subtitle: Text("aa")
              ),
          ],
        ),
      ),
    );*/
}

class DashboardBlock extends StatelessWidget {
  final Color color;
  final String title;
  final String content;
  final Color textColor;

  DashboardBlock(
      {required this.color,
      required this.title,
      required this.content,
      this.textColor = const Color.fromARGB(255, 2, 0, 38)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontStyle: FontStyle.italic)),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
                fontSize: 60, fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
