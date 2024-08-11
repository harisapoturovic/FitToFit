import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ChangeUsernameScreen extends StatefulWidget {
  final int userId;

  const ChangeUsernameScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _ChangeUsernameScreenState createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisniciProvider _korisniciProvider;

  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _currentUsernameController = TextEditingController();
  FocusNode _trenutnoFocusNode = FocusNode();
  bool usernameTaken = false;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  Future<Korisnici?> getUserFromUserId(int userId) async {
    final user = await _korisniciProvider.getById(userId);
    return user;
  }

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _trenutnoFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _trenutnoFocusNode.dispose();
    super.dispose();
  }

  Future<void> provjeriUsername(String username) async {
    try {
      var temp = await _korisniciProvider
          .get(filter: {"korisnickoIme": username, "isAdmin": true});
      if (mounted) {
        setState(() {
          usernameTaken = temp.count > 0;
          if (usernameTaken) {
            _showAlertDialog(
                "Greška", "Admin sa ovim username-om već postoji", Colors.red);
          }
        });
      }
    } catch (e) {
      print('Greška pri provjeri username-a: $e');
    }
  }

  Future<void> debouncedUsernameCheck(String username) async {
    debouncer.run(() async {
      await provjeriUsername(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izmjena korisničkog imena",
      selectedIndex: 0,
      child: Center(
        child: SingleChildScrollView(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_trenutnoFocusNode);
    });
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.blue.shade300, width: 3.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trenutno korisničko ime',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    FormBuilderTextField(
                      name: 'currentPassword',
                      controller: _currentUsernameController,
                      focusNode: _trenutnoFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Novo korisničko ime',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    FormBuilderTextField(
                      name: 'newUsername',
                      controller: _newUsernameController,
                      onChanged: (val) async {
                        if (val != null && val != '') {
                          debouncedUsernameCheck(val);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (value[0] != value[0].toUpperCase()) {
                          return 'Korisničko ime mora početi velikim slovom.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: const Text('Sačuvaj'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserData() async {
    if (usernameTaken == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Korisničko ime je već uzeto, unesite neko novo.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _formKey.currentState?.save();
    Korisnici? korisnik = await getUserFromUserId(widget.userId);

    try {
      final currentFormState = _formKey.currentState;

      if (!_areAllFieldsFilled(currentFormState)) {
        _showAlertDialog(
            "Greška", "Molimo unesite i trenutni i novi username!", Colors.red);
        return;
      }

      if (currentFormState != null) {
        if (!currentFormState.validate()) {
          _showAlertDialog("Greška",
              "Molimo unesite i trenutni i novi username!", Colors.red);
          return;
        }
      }

      if (korisnik?.korisnickoIme != _currentUsernameController.text) {
        _showAlertDialog(
            "Greška",
            "Trenutni username nije validan za prijavljenog korisnika!",
            Colors.red);
        return;
      }

      if (usernameTaken) {
        _showAlertDialog("Greška",
            "Korisničko ime koje ste unijeli je već zauzeto.", Colors.red);
        return;
      }

      try {
        await _korisniciProvider.changeUsername(
          widget.userId,
          _newUsernameController.text,
          _currentUsernameController.text,
        );

        Authorization.username = _newUsernameController.text;
        Provider.of<KorisniciProvider>(context, listen: false)
            .setCurrentUserId(widget.userId);
        _showAlertDialog("Korisničko ime promijenjeno",
            "Uspješno promijenjeno korisničko ime.", Colors.green);
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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An error occurred while updating credentials. Check the console for more information.',
          ),
        ),
      );
    }
  }

  bool _areAllFieldsFilled(FormBuilderState? formState) {
    if (formState == null) return false;

    final currentUsername = _currentUsernameController.text;
    final newUsername = _newUsernameController.text;

    return currentUsername.isNotEmpty && newUsername.isNotEmpty;
  }

  void _showAlertDialog(String naslov, String poruka, Color boja) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 238, 247, 255),
        title: Text(
          naslov,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: boja,
          ),
        ),
        content: Text(
          poruka,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              textStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            child: const Text("OK"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
