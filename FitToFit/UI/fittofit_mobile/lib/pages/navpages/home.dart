import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/models/korisniciNovosti.dart';
import 'package:fittofit_mobile/models/novosti.dart';
import 'package:fittofit_mobile/pages/cjenovnik.dart';
import 'package:fittofit_mobile/pages/novosti_detalji.dart';
import 'package:fittofit_mobile/pages/raspored.dart';
import 'package:fittofit_mobile/providers/korisnici_novosti_provider.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/custom_avatar.dart';
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
  late KorisniciProvider _korisniciProvider;
  late KorisniciNovostiProvider _korisniciNovostiProvider;
  List<Novosti> _novostiList = [];
  List<KorisniciNovosti> _korisniciNovostiList = [];
  late Korisnici korisnik;
  bool isLiked = false;
  bool isLoading = true;
  bool isSearching = false;
  String? korisnickoIme = '';
  final TextEditingController _naslovController = TextEditingController();

  var page = 1;
  var totalcount = 0;
  var pageSize = 4;

  @override
  void initState() {
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _korisniciNovostiProvider = context.read<KorisniciNovostiProvider>();
    initForm();
    _loadData();
  }

  Future initForm() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
  }

  void _loadData() async {
    if (!mounted) return;
    isSearching = false;
    korisnickoIme = await getUserName();
    var user = await _korisniciProvider
        .get(filter: {'korisnickoIme': korisnickoIme, 'isAdmin': false});
    var kn = await _korisniciNovostiProvider.get();

    if (mounted) {
      setState(() {
        korisnik = user.result[0];
        _korisniciNovostiList = kn.result;
        isLoading = false;
      });
    }

    var novosti = await _novostiProvider.get(filter: {
      'page': page,
      'pageSize': pageSize,
      'korisnikId': korisnik.korisnikId
    });
    if (mounted) {
      setState(() {
        _novostiList = novosti.result;
        totalcount = novosti.count;
      });
    }
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
          title: const Text('Početna'),
          backgroundColor: Colors.deepPurple.shade300,
          foregroundColor: Colors.white,
          leading: Container(),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: korisnik.slika != '' && korisnik.slika != null
                            ? CustomAvatar(
                                radius: 40, base64Image: korisnik.slika!)
                            : const CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                              ),
                        title: RichText(
                          text: TextSpan(
                            text: 'Dobrodošli, \n',
                            style: const TextStyle(
                              fontSize: 16,
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
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Naslov',
                          prefixIcon: Icon(Icons.search),
                        ),
                        controller: _naslovController,
                        onChanged: (value) {
                          _getFilteredNews();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CjenovnikPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 205, 151, 255),
                            foregroundColor: Colors.white,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RasporedPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 107, 189, 255),
                            foregroundColor: Colors.white,
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
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(Novosti novost) {
    KorisniciNovosti? korisniciNovosti = _korisniciNovostiList.firstWhere(
      (kn) =>
          kn.novostId == novost.novostId &&
          kn.korisnikId == korisnik.korisnikId,
    );
    novost.isRead = korisniciNovosti.isRead;
    novost.isLiked = korisniciNovosti.isLiked;
    bool canMarkAsRead = !novost.isRead!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              tileColor: novost.isRead!
                  ? Colors.white
                  : const Color.fromARGB(255, 250, 215, 212),
              leading: Icon(
                Icons.notifications_active_outlined,
                size: 35.0,
                color: Colors.deepPurple.shade200,
              ),
              title: Text(novost.naslov,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text(
                  '${DateFormat('dd.MM.yyyy').format(novost.datumObjave)} | ${novost.datumObjave.hour.toString().padLeft(2, '0')}:${novost.datumObjave.minute.toString().padLeft(2, '0')}h'),
              onTap: () {
                if (canMarkAsRead) {
                  setState(() {
                    novost.isRead = !novost.isRead!;
                    korisniciNovosti.isRead = !korisniciNovosti.isRead;

                    Novosti n = Novosti(
                        novostId: novost.novostId,
                        naslov: novost.naslov,
                        sadrzaj: novost.sadrzaj,
                        datumObjave: novost.datumObjave,
                        isLiked: novost.isLiked,
                        brojLajkova: novost.brojLajkova,
                        korisnikId: novost.korisnikId,
                        vrstaTreningaId: novost.vrstaTreningaId,
                        isRead: novost.isRead);

                    _novostiProvider.update(novost.novostId, n);

                    KorisniciNovosti kn = KorisniciNovosti(
                        korisniciNovostiId: korisniciNovosti.korisniciNovostiId,
                        korisnikId: korisniciNovosti.korisnikId,
                        novostId: korisniciNovosti.novostId,
                        isLiked: korisniciNovosti.isLiked,
                        isRead: korisniciNovosti.isRead);

                    _korisniciNovostiProvider.update(
                        korisniciNovosti.korisniciNovostiId, kn);
                  });
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovostiDetaljiPage(novost: novost),
                  ),
                );
              },
              trailing: novost.vrstaTreningaId != null && novost.isLiked != null
                  ? IconButton(
                      icon: novost.isLiked!
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        setState(() {
                          novost.isLiked = !novost.isLiked!;
                          korisniciNovosti.isLiked = !korisniciNovosti.isLiked;
                          if (novost.isLiked!) {
                            novost.brojLajkova++;
                          } else {
                            novost.brojLajkova--;
                          }

                          Novosti n = Novosti(
                              novostId: novost.novostId,
                              naslov: novost.naslov,
                              sadrzaj: novost.sadrzaj,
                              datumObjave: novost.datumObjave,
                              isLiked: novost.isLiked,
                              brojLajkova: novost.brojLajkova,
                              korisnikId: novost.korisnikId,
                              vrstaTreningaId: novost.vrstaTreningaId,
                              isRead: novost.isRead);

                          _novostiProvider.update(novost.novostId, n);

                          KorisniciNovosti kn = KorisniciNovosti(
                              korisniciNovostiId:
                                  korisniciNovosti.korisniciNovostiId,
                              korisnikId: korisniciNovosti.korisnikId,
                              novostId: korisniciNovosti.novostId,
                              isLiked: korisniciNovosti.isLiked,
                              isRead: korisniciNovosti.isRead);

                          _korisniciNovostiProvider.update(
                              korisniciNovosti.korisniciNovostiId, kn);
                        });
                      },
                    )
                  : const SizedBox(),
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
                isSearching ? _getFilteredNews() : _loadData();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade100,
              foregroundColor: Colors.black,
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

  Future<void> _getFilteredNews() async {
    isSearching = true;
    var data = await _novostiProvider.get(filter: {
      'naslov': _naslovController.text,
      'korisnikId': korisnik.korisnikId,
      'page': page,
      'pageSize': pageSize
    });

    setState(() {
      _novostiList = data.result;
      totalcount = data.count;
    });
  }
}
