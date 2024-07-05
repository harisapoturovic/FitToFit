
import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
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

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

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
              const Text(
                'Uredi Lozinku',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Colors.purple, width: 3.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trenutna Lozinka',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        name: 'currentPassword',
                        controller: _currentPasswordController,
                      ),
                      const Text(
                        'Nova Lozinka',
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
          _showAlertDialog("Please enter both current and new usernames!");
          return;
        }

        if (currentFormState != null) {
          if (!currentFormState.validate()) {
            _showAlertDialog("Please enter both current and new usernames!");
            return;
          }
        }

        // Call the method to change the password
        try {
          await _korisniciProvider.changePassword(
            widget.userId,
            newPassword,
            currentPassword,
          );

          Authorization.password = newPassword;

          var userId = widget.userId;

          // ignore: use_build_context_synchronously
          Provider.of<KorisniciProvider>(context, listen: false)
              .setCurrentUserId(widget.userId);

          if (userId != null) {
            /*Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  username: data.result[0].korisnickoIme,
                ),
              ),
            );*/
          }
        } on FormatException catch (_) {
          _showAlertDialog("Invalid password.");
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
      print('Error updating credentials: $error');
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

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
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
