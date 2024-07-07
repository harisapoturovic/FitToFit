import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/models/novosti.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:fittofit_mobile/providers/novosti_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  final String username;
  const HomePage(
      {Key? key, required this.selectedIndex, required this.username})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NovostiProvider _novostiProvider;
  late KorisniciProvider _korisniciProvider;
  List<Novosti> _novostiList = [];
  late Korisnici korisnik;
  bool isLiked = false;
  bool isLoading = true;

  var page = 1;
  var totalcount = 0;
  var pageSize = 4;

  @override
  void initState() {
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    initForm();
    _loadData();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  void _loadData() async {
    var novosti = await _novostiProvider
        .get(filter: {'page': page, 'pageSize': pageSize});

    var user = await _korisniciProvider.get(filter: {
      'username': widget.username,
    });
    setState(() {
      _novostiList = novosti.result;
      totalcount = novosti.count;
      korisnik = user.result[0];
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
                        text: TextSpan(
                          text: 'Dobrodošli, \n',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${korisnik.ime} ${korisnik.prezime}',
                              style: const TextStyle(
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
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: _novostiList.length,
                    itemBuilder: (context, index) {
                      return isLoading
                          ? Container()
                          : _buildNewsCard(_novostiList[index]);
                    },
                  ),
                ),
                _buildPageNumbers(),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNewsCard(Novosti novost) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_sharp),
              title: Text(novost.naslov),
              subtitle: Text(
                  '${DateFormat('dd.MM.yyyy').format(novost.datumObjave)} | vrijemeToDo'),
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
          )
        ],
      ),
    );
  }

  Widget _buildPageNumbers() {
    int totalPages = (totalcount / pageSize).ceil();
    List<Widget> pageButtons = [];

    for (int i = 1; i <= totalPages; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                page = i;
                _loadData();
              });
            },
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 240, 215, 245),
              onPrimary: Colors.black,
            ),
            child: Text('$i'),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageButtons,
    );
  }
}
