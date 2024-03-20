import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../pages/korisnici.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  final Widget? floatingActionButton;
  String? username;
  MasterScreenWidget(
      {this.child,
      this.title,
      super.key,
      this.floatingActionButton,
      this.username});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int selectedIndex = 0;
  int hoverIndex = -1;
  String korisnickoIme = '';

  @override
  void initState() {
    super.initState();
    korisnickoIme = widget.username??'';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1).withOpacity(0.9),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 100.0),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  korisnickoIme,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            backgroundColor:
                const Color.fromRGBO(0, 154, 231, 1).withOpacity(0.9),
            unselectedIconTheme: IconThemeData(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            selectedIconTheme: IconThemeData(
              color: const Color.fromRGBO(0, 154, 231, 1),
            ),
            destinations: [
              NavigationRailDestination(
                icon: buildIcon(Icons.home, 0, 'Home', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => KorisniciPage(),
                    ),
                  );
                }),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: buildIcon(Icons.search, 1, 'Search', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => KorisniciPage(),
                    ),
                  );
                }),
                label: Text('Search'),
              ),
            ],
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Center(
              child: widget.child!,
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget buildIcon(
      IconData icon, int index, String labelText, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      onHover: (bool isHovered) {
        setState(() {
          hoverIndex = isHovered ? index : -1;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Icon(icon),
        decoration: BoxDecoration(
          color: (hoverIndex == index || selectedIndex == index)
              ? Color.fromARGB(255, 231, 230, 230)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}


    /*Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(widget.title ?? ""),
        leading: Image.asset("assets/images/teg.png",
                    height: 1000,
                    width: 1000,),
                    
      ),
      body: widget.child!*/