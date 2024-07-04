import 'package:fittofit_mobile/pages/bottomNavBar.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  final int selectedIndex;
  const TrainingPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Training Page'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('Training Page Content'),
              ],
            ),
          )),
    );
  }
}
