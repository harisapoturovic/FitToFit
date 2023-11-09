import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/novosti_provider';
import '../utils/util.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  late NovostiProvider _novostiProvider;


  @override
  Widget build(BuildContext context) {
    _novostiProvider = context.read<NovostiProvider>();
      return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.lightBlue,
          ),
        body: Center(
        child: Container(
           constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                    width: 150,
                  ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.email),                    
                    ),
                    controller: _usernameController,
                  ),
                  SizedBox(height: 8,),
                  TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.password)
                    ),
                    controller: _passwordController,
                  ),
                  SizedBox(height: 8,),
                  ElevatedButton(onPressed: () async {
                    var username = _usernameController.text;
                        var password = _passwordController.text;
                        
                        Authorization.username = username;
                        Authorization.password = password;

                        try {
                          await _novostiProvider.get();

                          print("login proceed $username $password");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage()));
                        } on Exception catch (e) {
                          showDialog(context: context, 
                          builder: (BuildContext context)=> AlertDialog(
                            title: Text("Error"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))
                            ],
                          ));
                        }
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