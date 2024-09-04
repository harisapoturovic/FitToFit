import 'package:fittofit_mobile/models/akcije.dart';
import 'package:fittofit_mobile/models/recommender.dart';
import 'package:fittofit_mobile/models/search_result.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/pages/treninzi_detalji.dart';
import 'package:fittofit_mobile/providers/akcije_provider.dart';
import 'package:fittofit_mobile/providers/recommender_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TreninziDetaljiPage2 extends StatefulWidget {
  final Treninzi trening;
  const TreninziDetaljiPage2({Key? key, required this.trening})
      : super(key: key);

  @override
  State<TreninziDetaljiPage2> createState() => _TreninziDetaljiPage2State();
}

class _TreninziDetaljiPage2State extends State<TreninziDetaljiPage2> {
  late AkcijeProvider _akcijeProvider;
  late RecommenderProvider _recommenderProvider;
  late TreninziProvider _treninziProvider;
  bool isLoading = true;

  @override
  void initState() {
    _akcijeProvider = context.read<AkcijeProvider>();
    _recommenderProvider = context.read<RecommenderProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    super.initState();
    initForm();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  Future<List<Akcije>> getAkcije(int treningId) async {
    final akcija = await _akcijeProvider.getAkcijeForTrening(treningId);
    return akcija;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: 1,
        child: Scaffold(
            appBar: AppBar(
                title: Text('${widget.trening.naziv} :: opis'),
                backgroundColor: Colors.deepPurple.shade300,
                foregroundColor: Colors.white),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: isLoading ? Container() : _buildNewsDetailsCard(),
            )));
  }

  Widget _buildNewsDetailsCard() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opis',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.trening.opis,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 15),
            const Text(
              'Vježbe',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            widget.trening.treninziVjezbes == null ||
                    widget.trening.treninziVjezbes!.isEmpty
                ? const Text('No exercises available')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.trening.treninziVjezbes!.length,
                    itemBuilder: (context, index) {
                      var vjezba =
                          widget.trening.treninziVjezbes![index].vjezba!;
                      var trajanje =
                          widget.trening.treninziVjezbes![index].trajanje;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: vjezba.slika != null &&
                                            vjezba.slika != ''
                                        ? Container(
                                            width: 300.0,
                                            height: 250.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              image: DecorationImage(
                                                image: imageFromBase64String(
                                                        vjezba.slika!)
                                                    .image,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 300.0,
                                            height: 250.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.asset(
                                                'assets/images/vjezba.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 30),
                                    Text(
                                      vjezba.naziv,
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$trajanje minuta',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
            const SizedBox(height: 15),
            const Text(
              'Akcije',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder<List<Akcije>>(
              future: getAkcije(widget.trening.treningId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Učitavanje akcija...'));
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Greška pri učitavanju: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final akcijeList = snapshot.data!;
                  if (akcijeList.isEmpty) {
                    return const Text('Nema dostupnih akcija.');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: akcijeList.length,
                      itemBuilder: (context, index) {
                        final akcija = akcijeList[index];
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: akcija.naziv,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                TextSpan(
                                  text:
                                      ' (${formatDate(akcija.datumPocetka)} - ${formatDate(akcija.datumZavrsetka)})',
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text('- ${akcija.iznos} %',
                              style: const TextStyle(fontSize: 16)),
                        );
                      },
                    );
                  }
                } else {
                  return const Text('Nema dostupnih akcija.');
                }
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<int>>(
                future: getRecommendedTreninziIds(widget.trening.treningId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var recTreninziIds = snapshot.data!;

                    if (recTreninziIds.isEmpty) {
                      return Container();
                    }
                    return FutureBuilder<SearchResult<Treninzi>>(
                        future: _treninziProvider.get(filter: {
                          "Ids": recTreninziIds,
                          'isVjezbeIncluded': true
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var recTreninziList = snapshot.data!.result;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                      "Treninzi koje vam predlažemo uz ${widget.trening.naziv}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      )),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children:
                                        _buildRecTreninziCards(recTreninziList),
                                  ),
                                )
                              ],
                            );
                          }
                        });
                  }
                })
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecTreninziCards(List<Treninzi> recTreninziList) {
    return recTreninziList.map((trening) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreninziDetaljiPage(trening: trening),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRect(
                  child: trening.slika != null && trening.slika != ''
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image:
                                    imageFromBase64String(trening.slika!).image,
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
                              width: 100.0,
                              height: 100.0,
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
                const SizedBox(height: 8),
                Text(
                  trening.naziv,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trening.namjena,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trening.trajanje,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<List<int>> getRecommendedTreninziIds(int treningId) async {
    try {
      Recommender recData = await _recommenderProvider.getById(treningId);

      int? coTreningId1 = recData.coTreningId1;
      int? coTreningId2 = recData.coTreningId2;
      int? coTreningId3 = recData.coTreningId3;

      List<int> recommendedTreninziIds = [];

      if (coTreningId1 != null) {
        Recommender recTrening1 =
            await _recommenderProvider.getById(coTreningId1);
        recommendedTreninziIds.add(recTrening1.treningId!);
      }

      if (coTreningId2 != null) {
        Recommender recTrening2 =
            await _recommenderProvider.getById(coTreningId2);
        recommendedTreninziIds.add(recTrening2.treningId!);
      }

      if (coTreningId3 != null) {
        Recommender recTrening3 =
            await _recommenderProvider.getById(coTreningId3);
        recommendedTreninziIds.add(recTrening3.treningId!);
      }

      return recommendedTreninziIds;
    } catch (e) {
      return [];
    }
  }
}
