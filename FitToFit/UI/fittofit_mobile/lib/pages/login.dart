import 'package:fittofit_mobile/pages/navpages/home.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.6),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints:
                    const BoxConstraints(maxHeight: 500, maxWidth: 350),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "Korisničko ime",
                            prefixIcon: Icon(Icons.person),
                          ),
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Lozinka",
                            prefixIcon: Icon(Icons.lock),
                          ),
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            var username = _usernameController.text;
                            var password = _passwordController.text;

                            Authorization.username = username;
                            Authorization.password = password;

                            try {
                              print("login proceed $username $password");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const HomePage(selectedIndex: 0,)));
                            } on Exception catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 107, 189, 255),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Prijava",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text("Nemate korisnički račun?",
                            style: TextStyle(
                                color: Color.fromARGB(255, 105, 105, 105))),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 209, 173, 244),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Registracija",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
