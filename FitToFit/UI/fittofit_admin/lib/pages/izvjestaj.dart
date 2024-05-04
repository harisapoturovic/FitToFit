import 'package:fittofit_admin/models/odabraniTermini.dart';
import 'package:fittofit_admin/models/rezervacijaStavke.dart';
import 'package:fittofit_admin/models/termini.dart';
import 'package:fittofit_admin/models/treneri.dart';
import 'package:fittofit_admin/providers/rezervacije_stavke_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class IzvjestajPage extends StatefulWidget {
  const IzvjestajPage({Key? key}) : super(key: key);

  @override
  State<IzvjestajPage> createState() => _IzvjestajPageState();
}

class _IzvjestajPageState extends State<IzvjestajPage> {
  late TreneriProvider _treneriProvider;
  late RezervacijeStavkeProvider _rezervacijeStavkeProvider;
  List<Treneri> _treneriList = [];
  List<OdabraniTermini> _terminiList = [];
  String? _selectedTrener;
  Treneri? _trener;
  late double ocjenaJedan = 0;
  late double ocjenaDva = 0;
  late double ocjenaTri = 0;
  late double ocjenaCetiri = 0;
  late double ocjenaPet = 0;
  Map<String, double> dataMap = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0};

  @override
  void initState() {
    super.initState();
    _treneriProvider = context.read<TreneriProvider>();
    _rezervacijeStavkeProvider = context.read<RezervacijeStavkeProvider>();
    _loadData();
  }

  void _loadData() async {
    var treneri =
        await _treneriProvider.get(filter: {'IsOcjeneIncluded': true});
    var termini = await _rezervacijeStavkeProvider.getTop3Terms("desc");

    setState(() {
      _treneriList = treneri.result;
      _terminiList = termini;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Izvještaj",
        child: Row(
          children: [
            SizedBox(
              width: 200,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _treneriList.map((trener) {
                  bool isSelected =
                      '${trener.ime} ${trener.prezime}' == _selectedTrener;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedTrener = isSelected
                              ? null
                              : '${trener.ime} ${trener.prezime}';
                          _trener = trener;
                          ocjenaJedan = 0;
                          ocjenaDva = 0;
                          ocjenaTri = 0;
                          ocjenaCetiri = 0;
                          ocjenaPet = 0;
                          if (_trener?.ocjenes != null) {
                            for (var i = 0; i < _trener!.ocjenes!.length; i++) {
                              // ignore: unrelated_type_equality_checks
                              if (_trener!.ocjenes![i].ocjena == 1) {
                                ocjenaJedan += 1;
                              } else if (_trener!.ocjenes![i].ocjena == 2) {
                                ocjenaDva += 1;
                              } else if (_trener!.ocjenes![i].ocjena == 3) {
                                ocjenaTri += 1;
                              } else if (_trener!.ocjenes![i].ocjena == 4) {
                                ocjenaCetiri += 1;
                              } else if (_trener!.ocjenes![i].ocjena == 5) {
                                ocjenaPet += 1;
                              }
                            }
                          }
                          dataMap = {
                            "1": ocjenaJedan,
                            "2": ocjenaDva,
                            "3": ocjenaTri,
                            "4": ocjenaCetiri,
                            "5": ocjenaPet
                          };
                        });
                      },
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                            (states) {
                          if (isSelected) {
                            return const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            );
                          } else {
                            return const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            );
                          }
                        }),
                      ),
                      child: Text('${trener.ime} ${trener.prezime}'),
                    ),
                  );
                }).toList(),
              ),
            ),
            //ocjene za trenere
            SizedBox(
              width: 400,
              height: 400,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                //colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                centerText: _trener != null
                    // ignore: prefer_interpolation_to_compose_strings
                    ? "OCJENE ZA: " + _trener!.ime + ' ' + _trener!.prezime
                    : "OCJENE ZA: ",
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.top,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 0,
                ),
              ),
            ),
            //najposjećeniji termini
            SizedBox(
              width: 400,
              height: 400,
              child: PieChart(
                dataMap: {
                  _terminiList[0].opis:
                      double.tryParse(_terminiList[0].count.toString()) ?? 0.0,
                  _terminiList[1].opis:
                      double.tryParse(_terminiList[1].count.toString()) ?? 0.0,
                  _terminiList[2].opis:
                      double.tryParse(_terminiList[2].count.toString()) ?? 0.0
                },
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                //colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: "TOP 3 NAJPOSJEĆENIJA TERMINA",
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: true,
                  decimalPlaces: 0,
                ),
              ),
            )
          ],
        ));
  }
}
