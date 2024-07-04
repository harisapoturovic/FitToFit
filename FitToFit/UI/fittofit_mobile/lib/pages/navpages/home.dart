import 'package:fittofit_mobile/models/novosti.dart';
import 'package:fittofit_mobile/pages/bottomNavBar.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:fittofit_mobile/providers/novosti_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
   final int selectedIndex;

  const HomePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NovostiProvider _novostiProvider;
  List<Novosti> _novostiList = [];

  var page = 1;
  var totalcount = 0;
  var pageSize = 4;

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    _loadData();
  }

  void _loadData() async {
    var novosti = await _novostiProvider
        .get(filter: {'page': page, 'pageSize': pageSize});

    setState(() {
      _novostiList = novosti.result;
      totalcount = novosti.count;
    });
  }

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome John'),
              const Text('Home Page Content.'),
              Text(totalcount.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
