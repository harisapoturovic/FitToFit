import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  final Widget? floatingActionButton;
  MasterScreenWidget(
      {this.child, this.title, super.key, this.floatingActionButton});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int selectedIndex = 0;
  int hoverIndex = -1;
  String korisnickoIme = '';
  late KorisniciProvider _korisniciProvider;
  Korisnici? odabraniKorisnik;

  @override
  void initState() {
    super.initState();
    korisnickoIme = "${Authorization.username}";
    _korisniciProvider = context.read<KorisniciProvider>();
    _loadData();
  }

  void _loadData() async {
    var korisnik = await _korisniciProvider
        .get(filter: {'isAdmin': true, 'korisnickoIme': korisnickoIme});
    setState(() {
      odabraniKorisnik = korisnik.result[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1).withOpacity(0.9),
        elevation: 0,
       ),
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
          color: (hoverIndex == index || selectedIndex == index)
              ? const Color.fromARGB(255, 231, 230, 230)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(icon),
      ),
    );
  }
}