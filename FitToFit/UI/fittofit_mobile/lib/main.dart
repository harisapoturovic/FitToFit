import 'package:fittofit_mobile/pages/login.dart';
import 'package:fittofit_mobile/providers/acTrening_provider.dart';
import 'package:fittofit_mobile/providers/akcije_provider.dart';
import 'package:fittofit_mobile/providers/akcije_treninzi_provider.dart';
import 'package:fittofit_mobile/providers/clanarine_provider.dart';
import 'package:fittofit_mobile/providers/korisnici_novosti_provider.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/providers/novosti_provider.dart';
import 'package:fittofit_mobile/providers/ocjene_provider.dart';
import 'package:fittofit_mobile/providers/recommender_provider.dart';
import 'package:fittofit_mobile/providers/rezervacije_provider.dart';
import 'package:fittofit_mobile/providers/rezervacije_stavke_provider.dart';
import 'package:fittofit_mobile/providers/sale_provider.dart';
import 'package:fittofit_mobile/providers/termini_provider.dart';
import 'package:fittofit_mobile/providers/treneri_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_clanarine_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_provider.dart';
import 'package:fittofit_mobile/providers/vjezbe_provider.dart';
import 'package:fittofit_mobile/providers/vjezbe_treninzi_provider.dart';
import 'package:fittofit_mobile/providers/vrste_treninga_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sp.Stripe.publishableKey = const String.fromEnvironment(
      'STRIPE_PUBLISHABLE_KEY',
      defaultValue:
          "pk_test_51PnjR5Rum3JuFfOBmRLxQ7Lje6AsBK8iBU5omkXhC55I3UgjC9ZD9AjnOyofza3KQaOMgMuHCOoG7iqdGKzrroFh008IjgEvie");
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
        ChangeNotifierProvider(create: (_) => RezervacijeStavkeProvider()),
        ChangeNotifierProvider(create: (_) => KorisniciNovostiProvider()),
        ChangeNotifierProvider(create: (_) => OcjeneProvider()),
        ChangeNotifierProvider(create: (_) => RecommenderProvider()),
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
