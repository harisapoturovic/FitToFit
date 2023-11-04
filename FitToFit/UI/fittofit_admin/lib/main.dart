import 'package:fittofit_admin/providers/novosti_provider';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login.dart';

void main() {
   runApp(
  MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => NovostiProvider())],
    child: const MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My material app",
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: LoginPage()
      /*Scaffold(
        appBar: AppBar(
          title: const Text("korisnicko ime", 
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          textAlign: TextAlign.right
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Enter your name"
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              print("Button clicked");
            }, 
            child: const Text("Submit"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {},
      child: const Icon(Icons.add),
      ),
    )*/
    );
  }
}

