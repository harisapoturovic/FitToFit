import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../utils/util.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  late NovostiProvider _novostiProvider;
  late TreneriProvider _treneriProvider;

  @override
  Widget build(BuildContext context) {
    _novostiProvider = context.read<NovostiProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 154, 231, 1).withOpacity(0.9),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 18),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    // Navigate to the sign-up page or show a sign-up dialog
                  },
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15) // White border
                      ),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
              ],
            ),
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[80],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: const Color.fromRGBO(0, 154, 231, 1),
                            ),
                          ),
                        ),
                        controller: _usernameController,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.password),
                          filled: true,
                          fillColor: Colors.grey[80],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: const Color.fromRGBO(0, 154, 231, 1),
                            ),
                          ),
                        ),
                        controller: _passwordController,
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () async {
                          var username = _usernameController.text;
                          var password = _passwordController.text;

                          Authorization.username = username;
                          Authorization.password = password;

                          try {
                            await _novostiProvider.get();
                            await _treneriProvider.get();

                            print("login proceed $username $password");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HomePage()));
                          } on Exception catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("OK"))
                                      ],
                                    ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(0, 154, 231, 1),
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Calibri",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ), /*
      floatingActionButton: FloatingActionButton(onPressed: () {},
      child: Icon(Icons.add),
      ),*/
    );
  }
}
