import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/models/novosti.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/providers/novosti_provider.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NovostiDetaljiPage extends StatefulWidget {
  final Novosti novost;

  const NovostiDetaljiPage({Key? key, required this.novost}) : super(key: key);

  @override
  _NovostiDetaljiPage createState() => _NovostiDetaljiPage();
}

class _NovostiDetaljiPage extends State<NovostiDetaljiPage> {
  late NovostiProvider _novostiProvider;
  late KorisniciProvider _korisniciProvider;
  bool isLoading = true;

  @override
  void initState() {
    _novostiProvider = context.read<NovostiProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    super.initState();

    initForm();
  }

  Future<Korisnici?> getUserFromUserId(int userId) async {
    final user = await _korisniciProvider.getById(userId);
    return user;
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Detalji o novosti'),
                backgroundColor: Colors.deepPurple.shade300),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: isLoading ? Container() : _buildNewsDetailsCard(),
            )));
  }

  Widget _buildNewsDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.deepPurple.shade200,
          width: 3.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.notifications_active_outlined,
                  size: 50.0, color: Colors.deepPurple.shade200),
            ),
            const SizedBox(height: 30),
            Text(
              widget.novost.naslov,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            FutureBuilder<Korisnici?>(
              future: getUserFromUserId(widget.novost.korisnikId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final author = snapshot.data;
                  if (author != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Objavio: ${author.ime} ${author.prezime}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Datum objave: ${DateFormat('dd.MM.yyyy').format(widget.novost.datumObjave)}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          "Broj lajkova: ${widget.novost.brojLajkova}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    );
                  } else {
                    return const Text("Nepoznat autor");
                  }
                } else {
                  return const Text("Učitavanje autora...");
                }
              },
            ),
            const SizedBox(height: 15),
            Text(
              widget.novost.sadrzaj!,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
