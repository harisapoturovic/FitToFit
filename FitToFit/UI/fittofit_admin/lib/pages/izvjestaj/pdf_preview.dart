import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  // ignore: prefer_typing_uninitialized_variables
  var data2;
  PdfPreviewPage({Key? key, required this.data, required this.data2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(data),
      ),
    );
  }

  Future<Uint8List> makePdf(var invoice) async {
    final pdf = pw.Document();
    final imageLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.SizedBox(
                  height: 100,
                  width: 100,
                  child: pw.Image(imageLogo),
                ),
                pw.Container(height: 50),
                pw.Text(
                    "U ovom izvjestaju su predstavljeni razliciti statisticki podaci koji pruzaju detaljan pregled i analizu kljucnih indikatora. Podaci su prikazani kroz tabele kako bi se olaksalo razumijevanje i interpretacija informacija. Izvjestaj prikazuje top 3 najposjecenija termina, te ujedno i one treninge od kojih se dobiva najveci profit. Pored toga, prikazan je i ostvareni prihod kroz historiju, cime mozete zakljuciti da li je ostvaren napredak u odnosu na prethodne godine."),
                pw.Container(height: 50),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(
                      children: [
                        PaddedText("Opis"),
                        PaddedText(
                          "Vrijednost",
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        PaddedText("${data[0].naziv}"),
                        PaddedText(
                          "${data[0].vrijednost}",
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        PaddedText("${data[1].naziv}"),
                        PaddedText(
                          "${data[1].vrijednost}",
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        PaddedText("${data[2].naziv}"),
                        PaddedText(
                          "${data[2].vrijednost}",
                        )
                      ],
                    ),
                  ],
                ),
                pw.Container(height: 50),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(
                      children: [
                        PaddedText("Opis"),
                        PaddedText(
                          "Vrijednost",
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        PaddedText("${data2[0].naziv}"),
                        PaddedText(
                          "${data2[0].vrijednost + ' KM'}",
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        PaddedText("${data2[1].naziv}"),
                        PaddedText(
                          "${data2[1].vrijednost + ' KM'}",
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        PaddedText("${data2[2].naziv}"),
                        PaddedText(
                          "${data2[2].vrijednost + ' KM'}",
                        )
                      ],
                    ),
                  ],
                ),
                pw.Container(height: 130),
                pw.Text(DateFormat('dd.MM.yyyy').format(DateTime.now())),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget PaddedText(final String text,
      {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        textAlign: align,
      ),
    );
  }
}
