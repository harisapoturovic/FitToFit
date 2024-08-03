import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userId;

  const ChangePasswordScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisniciProvider _korisniciProvider;

  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();

  Future<Korisnici?> getUserFromUserId(int userId) async {
    final user = await _korisniciProvider.getById(userId);
    return user;
  }

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izmjena lozinke",
      selectedIndex: 0,
      child: Center(
        child: SingleChildScrollView(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
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
                        'Trenutna lozinka',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        name: 'currentPassword',
                        controller: _currentPasswordController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Nova lozinka',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        name: 'newPassword',
                        controller: _newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno!';
                          } else if (value.length < 8 ||
                              !value.contains(RegExp(r'[A-Z]')) ||
                              !value.contains(RegExp(r'[a-z]')) ||
                              !value.contains(RegExp(r'[0-9]'))) {
                            return '8 karaktera,uključujući najmanje jedno veliko slovo (A-Z), jedno malo slovo (a-z) i jednu cifru (0-9)';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updatePassword,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade300,
                            onPrimary: Colors.white,
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
          )),
    );
  }

  void _updatePassword() async {
    _formKey.currentState?.save();

    try {
      if (_formKey.currentState!.validate()) {
        String newPassword = _newPasswordController.text;
        String currentPassword = _currentPasswordController.text;

        final currentFormState = _formKey.currentState;
        if (!_areAllFieldsFilled(currentFormState)) {
          _showAlertDialog("Greška",
              "Molimo unesite i trenutnu i novu lozinku!", Colors.red);
          return;
        }

        if (currentFormState != null) {
          if (!currentFormState.validate()) {
            _showAlertDialog("Greška",
                "Molimo unesite i trenutnu i novu lozinku!", Colors.red);
            return;
          }
        }

        try {
          await _korisniciProvider.changePassword(
            widget.userId,
            newPassword,
            currentPassword,
          );

          Authorization.password = newPassword;

          Provider.of<KorisniciProvider>(context, listen: false)
              .setCurrentUserId(widget.userId);
          _showAlertDialog("Lozinka promijenjena",
              "Uspješno promijenjena lozinka.", Colors.green);
        } on FormatException catch (_) {
          _showAlertDialog("Greška", "Netačna lozinka!", Colors.red);
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

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;

    return currentPassword.isNotEmpty && newPassword.isNotEmpty;
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
              primary: Colors.blue,
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
