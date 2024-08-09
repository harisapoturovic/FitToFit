import 'package:fittofit_admin/pages/registracija.dart';
import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/util.dart';
import 'home.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                const Text(
                  "Nemate korisnički račun?",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 18),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistracijaPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15)),
                  child: const Text(
                    "REGISTRUJ SE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
              ],
            ),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
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
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Korisničko ime",
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[80],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 154, 231, 1),
                            ),
                          ),
                        ),
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Lozinka",
                          prefixIcon: const Icon(Icons.password),
                          filled: true,
                          fillColor: Colors.grey[80],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 154, 231, 1),
                            ),
                          ),
                        ),
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 25),
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
                                builder: (context) =>
                                    HomePage(username: username)));
                          } on Exception catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("OK"))
                                      ],
                                    ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "PRIJAVI SE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Calibri",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
