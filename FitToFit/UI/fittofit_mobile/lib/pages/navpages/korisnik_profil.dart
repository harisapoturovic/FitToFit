import 'package:fittofit_mobile/pages/bottomNavBar.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;
  const ProfilePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex:3,
      child: Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text('Profile Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Profile Page Content'),
            ],
          ),
        )
      ),
    );
  }
}
