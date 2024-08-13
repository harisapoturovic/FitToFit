import 'package:fittofit_admin/pages/izvjestaj/pdf_preview.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IzvjestajDetaljiPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  // ignore: prefer_typing_uninitialized_variables
  var data2;
  IzvjestajDetaljiPage({Key? key, required this.data, required this.data2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izvještaj - detalji",
      selectedIndex: 7,
      showBackArrow: true,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PdfPreviewPage(data: data, data2: data2),
              ),
            );
          },
          child: const Icon(Icons.picture_as_pdf),
        ),
        body: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 300, vertical: 120),
              child: Card(
                child: Column(
                  children: [
                    Text(
                      'Top 3 najposjećenija termina',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ...data.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: ListTile(
                          title: Text(e.naziv),
                          trailing: Text(
                            e.vrijednost,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300),
              child: Card(
                child: Column(
                  children: [
                    Text(
                      'Ostvareni profit po godinama',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ...data2.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: ListTile(
                          title: Text(e.naziv),
                          trailing: Text(
                            e.vrijednost + ' KM',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
