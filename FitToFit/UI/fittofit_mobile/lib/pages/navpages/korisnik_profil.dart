import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;
  const ProfilePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
            backgroundColor: const Color.fromARGB(255, 152, 73, 212),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('Profile Page Content'),
              ],
            ),
          )),
    );
  }
}
