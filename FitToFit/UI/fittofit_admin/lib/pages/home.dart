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

  @override
  void initState() {
    super.initState();
/*
    _initialValue = {
      'naslov': widget.novost?.naslov,
      'sadrzaj': widget.novost?.sadrzaj,
      'brojLajkova': widget.novost?.brojLajkova?.toString(),
      'datumObjave': widget.novost?.datumObjave?.toString(),
      'korisnikId': widget.novost?.korisnikId?.toString(),
      'vrstaTreningaId': widget.novost?.vrstaTreningaId?.toString()
    };*/
    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _vrsteTreningaProvider = context.read<VrsteTreningaProvider>();
    _treneriProvider=context.read<TreneriProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    korisniciResult = await _korisniciProvider.get();
    print(korisniciResult);
    vrsteTreningaResult = await _vrsteTreningaProvider.get();
    print(vrsteTreningaResult);
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
      title: "Početna"
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.only(top: 80),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: "Naslov"),
            controller: _naslovController,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: "Vrsta treninga"),
            controller: _vrstaTrController,
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
            child: Text("Pretraga"),
             style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(0, 154, 231, 1)
            ),)
      ]),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          const DataColumn(
            label: Expanded(
              child: Text(
                "Naslov",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: Expanded(
              child: Text(
                "Sadrzaj",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: Expanded(
              child: Text(
                "Broj lajkova",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: Expanded(
              child: Text(
                "Datum objave",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: Expanded(
              child: Text(
                "Korisnik:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: Expanded(
              child: Text(
                "Uredi:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: Expanded(
              child: Text(
                "Izbriši:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
        rows: result?.result
                .map((Novosti e) => DataRow(
                        onSelectChanged: (selected) => {
                              if (selected == true)
                                {
                                  /*
                        
                       Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: e),
                          ),
                        )*/
                                }
                            },
                        cells: [
                          DataCell(Text(e.naslov ?? "")),
                          DataCell(Text(e.sadrzaj ?? "")),
                          DataCell(Text(e.brojLajkova.toString())),
                          DataCell(Text(formatDate(e.datumObjave).toString())),
                          DataCell(Text(e.korisnikId.toString())),
                          DataCell(const Icon(Icons.edit, color: Colors.grey)),
                          DataCell(Icon(Icons.delete, color: Colors.grey))
                        ]))
                .toList() ??
            [],
      ),
    ));
  }

  String formatDate(DateTime? dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime!);
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
                color: Colors.black54.withBlue(70)
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, 
            children: [
              // First block
              Container(
                margin: EdgeInsets.only(right: 8), 
                width: MediaQuery.of(context).size.width * 0.22,
                height: 200,
                child: DashboardBlock(
                    color: Color.fromARGB(255, 223, 233, 245),
                    title: 'BROJ KORISNIKA',
                    content: '80'
                    ),
              ),
              // Second block
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                height: 200,
                child: DashboardBlock(
                  color: Color.fromARGB(255, 223, 233, 245),
                  title: 'BROJ TRENERA',
                  content: "2")
              ),
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
                      color: Color.fromARGB(255, 193, 211, 239),
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
      this.textColor = const Color.fromARGB(255, 2, 0, 38)
      });

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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor, fontStyle: FontStyle.italic)),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
