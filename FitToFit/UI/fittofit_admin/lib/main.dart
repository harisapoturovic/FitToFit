import 'package:fittofit_admin/pages/login.dart';
import 'package:fittofit_admin/providers/acTrening_provider.dart';
import 'package:fittofit_admin/providers/akcije_provider.dart';
import 'package:fittofit_admin/providers/akcije_treninzi_provider.dart';
import 'package:fittofit_admin/providers/clanarine_provider.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/rezervacije_provider.dart';
import 'package:fittofit_admin/providers/rezervacije_stavke_provider.dart';
import 'package:fittofit_admin/providers/sale_provider.dart';
import 'package:fittofit_admin/providers/termini_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:fittofit_admin/providers/treninzi_clanarine_provider.dart';
import 'package:fittofit_admin/providers/treninzi_provider.dart';
import 'package:fittofit_admin/providers/vjezbe_provider.dart';
import 'package:fittofit_admin/providers/vjezbe_treninzi_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        ChangeNotifierProvider(create: (_) => KorisniciProvider()),
        ChangeNotifierProvider(create: (_) => VrsteTreningaProvider()),
        ChangeNotifierProvider(create: (_) => TreneriProvider()),
        ChangeNotifierProvider(create: (_) => RezervacijeProvider()),
        ChangeNotifierProvider(create: (_) => TreninziProvider()),
        ChangeNotifierProvider(create: (_) => TerminiProvider()),
        ChangeNotifierProvider(create: (_) => AkcijeProvider()),
        ChangeNotifierProvider(create: (_) => AkcijeTreninziProvider()),
        ChangeNotifierProvider(create: (_) => AcTreningProvider()),
        ChangeNotifierProvider(create: (_) => ClanarineProvider()),
        ChangeNotifierProvider(create: (_) => TreninziClanarineProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => VjezbeProvider()),
        ChangeNotifierProvider(create: (_) => VjezbeTreninziProvider()),
        ChangeNotifierProvider(create: (_) => RezervacijeStavkeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.lightBlue, fontFamily: "Calibri"),
        home: LoginPage());
  }
}
