import 'package:fittofit_admin/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:fittofit_admin/providers/novosti_provider';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => NovostiProvider())],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: LoginPage()
    );
  }
}
