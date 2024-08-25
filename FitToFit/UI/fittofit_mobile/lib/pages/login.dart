import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/pages/navpages/home.dart';
import 'package:fittofit_mobile/pages/registracija.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late KorisniciProvider _korisniciProvider;

  @override
  Widget build(BuildContext context) {
    _korisniciProvider = context.read<KorisniciProvider>();
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
                              await setUserName(username);
                              var data = await _korisniciProvider.get(filter: {
                                "korisnickoIme": username,
                                "isUlogeIncluded": true
                              });
                              if (data.result.isNotEmpty) {
                                Korisnici korisnik = data.result[0];

                                if (korisnik.ulogaId == 1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HomePage(selectedIndex: 0),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text("Greška"),
                                      content: const Text(
                                          "Korisnik je registrovan, ali nema permisije za pristup mobilnoj aplikaciji."),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text("Greška"),
                                    content: const Text(
                                        "Niste ispravno unijeli korisničko ime ili lozinku, ili još niste registrovani."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } on Exception catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("$e"),
                                  content:
                                      const Text("Korisnik nije pronađen."),
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
                            backgroundColor:
                                const Color.fromARGB(255, 107, 189, 255),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "Prijava",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Nemate korisnički račun?",
                            style: TextStyle(
                                color: Color.fromARGB(255, 105, 105, 105))),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistracijaPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 209, 173, 244),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
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
