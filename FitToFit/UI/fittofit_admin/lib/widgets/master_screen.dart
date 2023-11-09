import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreenWidget({this.child, this.title, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        backgroundColor: Colors.lightBlue
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            backgroundColor: Colors.lightBlue,
            unselectedIconTheme: IconThemeData(
              color: Colors.white
            ),
            selectedIconTheme: IconThemeData(
              color: Colors.grey
            ),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text('Favorites'),
              ),
            ],
            onDestinationSelected: (int index) {
              // Handle the selection of a navigation item
            },
          ),
          Expanded(
            child: Center(
              child: widget.child!
            ),
          ),
        ],
        
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