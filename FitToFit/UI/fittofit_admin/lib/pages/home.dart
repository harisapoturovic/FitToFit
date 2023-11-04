import 'package:fittofit_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/novosti_provider';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
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