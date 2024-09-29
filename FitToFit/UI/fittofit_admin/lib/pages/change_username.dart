import 'dart:async';

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
  final TextEditingController _currentUsernameController =
      TextEditingController();
  FocusNode _trenutnoFocusNode = FocusNode();
  FocusNode _newUsernameFocusNode = FocusNode();
  Timer? _debounce;
  bool usernameTaken = false;
  String? _currentUsernameErrorMessage;
  String? _newUsernameErrorMessage;
  Future<Korisnici?> getUserFromUserId(int userId) async {
    final user = await _korisniciProvider.getById(userId);
    return user;
  }

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _trenutnoFocusNode = FocusNode();
    _newUsernameFocusNode = FocusNode();
    _newUsernameFocusNode.addListener(() {
      if (!_newUsernameFocusNode.hasFocus) {
        _checkNewUsername();
      }
    });
  }

  @override
  void dispose() {
    _trenutnoFocusNode.dispose();
    _newUsernameFocusNode.dispose();
    super.dispose();
  }

  void _checkNewUsername() {
    if (_newUsernameController.text.isNotEmpty) {
      provjeriUsername(_newUsernameController.text);
    }
  }

  void _onUsernameChanged(String? value) {
    if (value == null || value.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      provjeriUsername(value);
    });
  }

  Future<void> provjeriUsername(String username) async {
    try {
      var temp = await _korisniciProvider
          .get(filter: {"korisnickoIme": username, "isAdmin": true});
      if (mounted) {
        setState(() {
          usernameTaken = temp.count > 0;
          _newUsernameErrorMessage = usernameTaken
              ? "Admin sa ovim korisničkim imenom već postoji."
              : null;
        });
      }
    } catch (e) {
      print('Greška pri provjeri username-a: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izmjena korisničkog imena",
      selectedIndex: 0,
      showBackArrow: true,
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
      width: MediaQuery.of(context).size.width * 0.6,
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
                      decoration: InputDecoration(
                          errorText: _currentUsernameErrorMessage),
                      onChanged: (val) async {
                        Korisnici? korisnik =
                            await getUserFromUserId(widget.userId);
                        setState(() {
                          if (val != korisnik?.korisnickoIme) {
                            _currentUsernameErrorMessage =
                                "Trenutni username nije validan za prijavljenog korisnika.";
                          } else {
                            _currentUsernameErrorMessage = null;
                          }
                        });
                      },
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
                      focusNode: _newUsernameFocusNode,
                      decoration:
                          InputDecoration(errorText: _newUsernameErrorMessage),
                      onChanged: _onUsernameChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ovo polje je obavezno!';
                        } else if (value.length < 5) {
                          return 'Morate unijeti najmanje 5 karaktera.';
                        } else if (value.length > 50) {
                          return 'Premašili ste maksimalan broj karaktera (50).';
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
    _formKey.currentState?.saveAndValidate();
    if (_formKey.currentState!.validate()) {
      try {
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
              'Došlo je do greške prilikom promjene korisničkog imena. Molimo pokušajte ponovo.',
            ),
          ),
        );
      }
    }
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
             onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              textStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
