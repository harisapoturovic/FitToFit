import 'package:fittofit_mobile/models/akcije.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/providers/akcije_provider.dart';
import 'package:fittofit_mobile/providers/vjezbe_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TreninziDetaljiPage2 extends StatefulWidget {
  final Treninzi trening;
  const TreninziDetaljiPage2({Key? key, required this.trening})
      : super(key: key);

  @override
  State<TreninziDetaljiPage2> createState() => _TreninziDetaljiPage2State();
}

class _TreninziDetaljiPage2State extends State<TreninziDetaljiPage2> {
  late VjezbeProvider _vjezbeProvider;
  late AkcijeProvider _akcijeProvider;
  bool isLoading = true;

  @override
  void initState() {
    _vjezbeProvider = context.read<VjezbeProvider>();
    _akcijeProvider = context.read<AkcijeProvider>();
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
                backgroundColor: Colors.deepPurple.shade300),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.trening.treninziVjezbes!.length,
              itemBuilder: (context, index) {
                var vjezba = widget.trening.treninziVjezbes![index].vjezba!;
                var trajanje = widget.trening.treninziVjezbes![index].trajanje;

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
                              child: vjezba.slika != null && vjezba.slika != ''
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
                                      )),
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
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                } else {
                  return const Center(child: Text('Nema dostupnih akcija.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
