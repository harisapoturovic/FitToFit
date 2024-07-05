import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  final int selectedIndex;
  const TrainingPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Treninzi'),
            backgroundColor: const Color.fromARGB(255, 152, 73, 212),
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
