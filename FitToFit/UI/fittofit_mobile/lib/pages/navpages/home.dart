import 'package:fittofit_mobile/models/novosti.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:fittofit_mobile/providers/novosti_provider.dart';
import 'package:intl/intl.dart';
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
  bool isLiked = false;
  String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

  var page = 1;
  var totalcount = 0;
  var pageSize = 4;

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
    return DefaultTabController(
      length: 1,
      child: MasterScreenWidget(
        selectedIndex: 0,
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Početna'),
              backgroundColor: const Color.fromARGB(255, 152, 73, 212)),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Container(
                    height: 100,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      title: RichText(
                        text: const TextSpan(
                          text: 'Dobrodošli, \n',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Harisa Poturović',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('dd.MM.yyyy').format(DateTime.now()),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text('Home Page Content.'),
                Text('Count: $totalcount'),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.notifications_sharp),
                          title: const Text('Notification 1'),
                          subtitle: const Text('5.7.2024. | 12:00h'),
                          trailing: IconButton(
                            icon: isLiked
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.notifications_sharp),
                          title: const Text('Notification 2'),
                          subtitle: const Text('5.7.2024. | 15:00h'),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 205, 151, 255),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Cjenovnik",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 107, 189, 255),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Raspored",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
