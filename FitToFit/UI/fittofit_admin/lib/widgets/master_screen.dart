import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/pages/admin_profil.dart';
import 'package:fittofit_admin/pages/akcije.dart';
import 'package:fittofit_admin/pages/home.dart';
import 'package:fittofit_admin/pages/izvjestaj/izvjestaj.dart';
import 'package:fittofit_admin/pages/ponuda.dart';
import 'package:fittofit_admin/pages/rezervacije.dart';
import 'package:fittofit_admin/pages/treninzi.dart';
import 'package:fittofit_admin/pages/vjezbe.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/korisnici.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  final Widget? floatingActionButton;
  int? selectedIndex;
  MasterScreenWidget(
      {this.child,
      this.title,
      super.key,
      this.floatingActionButton,
      this.selectedIndex});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int _selectedIndex = 0;
  int hoverIndex = -1;
  String korisnickoIme = '';
  late KorisniciProvider _korisniciProvider;
  Korisnici? odabraniKorisnik;

  @override
  void initState() {
    super.initState();
    korisnickoIme = Authorization.username ?? '';
    _korisniciProvider = context.read<KorisniciProvider>();
    _selectedIndex = widget.selectedIndex!;
    _loadData();
  }

  void _loadData() async {
    if (korisnickoIme != '') {
      var korisnik = await _korisniciProvider
          .get(filter: {'isAdmin': true, 'korisnickoIme': korisnickoIme});
      setState(() {
        odabraniKorisnik = korisnik.result[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1).withOpacity(0.9),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 100.0),
            child: korisnickoIme != ''
                ? Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white),
                      const SizedBox(width: 8.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminProfilPage(
                                korisnik: odabraniKorisnik!,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          korisnickoIme,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
        ],
      ),
      body: Row(
        children: [
          korisnickoIme != ''
              ? NavigationRail(
                  selectedIndex: _selectedIndex,
                  backgroundColor:
                      const Color.fromRGBO(0, 154, 231, 1).withOpacity(0.9),
                  unselectedIconTheme: const IconThemeData(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  selectedIconTheme: const IconThemeData(
                    color: Color.fromRGBO(0, 154, 231, 1),
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Početna',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.home, 0, 'Home', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                username: korisnickoIme,
                              ),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Korisnici',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.search, 1, 'Search', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const KorisniciPage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Search'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Treninzi',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child:
                            buildIcon(Icons.fitness_center, 2, 'Training', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TreninziPage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Training'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Akcije',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.local_offer, 3, 'Actions', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AkcijePage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Actions'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Rezervacije',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.event, 4, 'Reservations', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RezervacijePage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Reservations'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Ponuda',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.local_mall, 5, 'Ponuda', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PonudaPage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Ponuda'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Vježbe',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.directions_run, 6, 'Vježbe', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const VjezbePage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Vježbe'),
                    ),
                    NavigationRailDestination(
                      icon: Tooltip(
                        message: 'Izvještaj',
                        textStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                        child: buildIcon(Icons.report, 7, 'Izvještaj', () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const IzvjestajPage(),
                            ),
                          );
                        }),
                      ),
                      label: const Text('Izvještaj'),
                    ),
                  ],
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                )
              : Container(),
          Expanded(
            child: Center(
              child: widget.child!,
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget buildIcon(
      IconData icon, int index, String labelText, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      onHover: (bool isHovered) {
        setState(() {
          hoverIndex = isHovered ? index : -1;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: (hoverIndex == index || _selectedIndex == index)
              ? const Color.fromARGB(255, 231, 230, 230)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(icon),
      ),
    );
  }
}
