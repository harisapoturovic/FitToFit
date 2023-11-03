import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
      ),
      body: Center(
        child: Container(
           constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Image.network("https://www.fit.ba/content/public/images/og-image.jpg", height: 150, width: 150,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.email)
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.password)
                    ),
                  ),
                  SizedBox(height: 8,),
                  ElevatedButton(onPressed: (){
                    print("login proceed");
                  }, child: Text("Login"))
              ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {},
      child: Icon(Icons.add),
      ),
    );
  }
}