import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final int selectedIndex;
  const ReservationPage({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Rezervacije'),
            backgroundColor: const Color.fromARGB(255, 152, 73, 212),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('Reservation Page Content'),
              ],
            ),
          )),
    );
  }
}
