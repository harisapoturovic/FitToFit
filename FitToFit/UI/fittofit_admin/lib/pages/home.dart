import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/novosti_provider';
import '../widgets/master_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late NovostiProvider _novostiProvider;

   @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _novostiProvider = context.read<NovostiProvider>();
  }
  
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Dobrodošli :)",
      child: Container(
      child: Column(
      children: [
        Text("TEST"),
        SizedBox(
          height: 8,
        ),
        ElevatedButton(
            onPressed: () async {
              print("login proceed");
              //Navigator.of(context).pop();

              var data = await _novostiProvider.get();
              print("data: ${data['result'][0]['naslov']}");
            },
            child: Text("Login"))
      ],
    )),
    );
  }
}