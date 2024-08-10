import 'package:fittofit_mobile/models/termini.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/pages/treninzi_detalji2.dart';
import 'package:fittofit_mobile/providers/termini_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TreninziDetaljiPage extends StatefulWidget {
  final Treninzi trening;

  const TreninziDetaljiPage({Key? key, required this.trening})
      : super(key: key);

  @override
  _TreninziDetaljiPage createState() => _TreninziDetaljiPage();
}

class _TreninziDetaljiPage extends State<TreninziDetaljiPage> {
  late TerminiProvider _terminiProvider;
  bool isLoading = true;

  @override
  void initState() {
    _terminiProvider = context.read<TerminiProvider>();
    super.initState();

    initForm();
  }

  Future<List<Termini>> getTermineByTreningId(int treningId) async {
    final termini =
        await _terminiProvider.get(filter: {'treningId': treningId});
    return termini.result;
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: 1,
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Detalji o treningu'),
                backgroundColor: Colors.deepPurple.shade300,
                foregroundColor: Colors.white),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: isLoading ? Container() : _buildNewsDetailsCard(),
            )));
  }

  Widget _buildNewsDetailsCard() {
    String kratkiOpis = widget.trening.opis.length <= 100
        ? widget.trening.opis
        : '${widget.trening.opis.substring(0, 100)}...';
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRect(
                child: widget.trening.slika != null &&
                        widget.trening.slika != ''
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          width: 300.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image:
                                  imageFromBase64String(widget.trening.slika!)
                                      .image,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                            width: 300.0,
                            height: 250.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                'assets/images/training.jpg',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.trening.naziv,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.trening.trajanje} | Max ${widget.trening.maxBrojClanova} osoba | ${widget.trening.namjena}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 15),
            const Text(
              'Opis',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              kratkiOpis,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TreninziDetaljiPage2(trening: widget.trening)),
                );
              },
              child: const Text(
                'Pročitaj više',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Termini',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Termini?>>(
              future: getTermineByTreningId(widget.trening.treningId),
              builder: (context, AsyncSnapshot<List<Termini?>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Grupisanje termina po danima
                    Map<String, List<Termini>> groupedByDay = {};
                    snapshot.data!.forEach((termin) {
                      String day = termin!.dan;
                      if (!groupedByDay.containsKey(day)) {
                        groupedByDay[day] = [];
                      }
                      groupedByDay[day]!.add(termin);
                    });

                    // Prikazivanje u ListView.separated
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedByDay.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, dayIndex) {
                        String day = groupedByDay.keys.elementAt(dayIndex);
                        List<Termini>? terminiZaDan = groupedByDay[day];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: terminiZaDan!.map((termin) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(termin.sat!),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Nema dostupnih termina za ovaj trening."),
                    );
                  }
                } else {
                  return const Center(child: Text("Učitavanje termina..."));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
