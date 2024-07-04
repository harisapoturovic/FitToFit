import 'package:fittofit_mobile/pages/navpages/home.dart';
import 'package:fittofit_mobile/pages/navpages/korisnik_profil.dart';
import 'package:fittofit_mobile/pages/navpages/rezervacije.dart';
import 'package:fittofit_mobile/pages/navpages/treninzi.dart';
import 'package:flutter/material.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;

  /// Controller for search
  TextEditingController? controller;

  /// onSubmitted event for search
  void Function(String)? onSubmitted;

  /// onClosed event for search
  void Function()? onClosed;

  /// onChanged event for search
  void Function(String)? onChanged;

  /// onCleared event for search
  void Function()? onCleared;
  bool? showBackArrow;
  bool? showSearch;
  Widget? floatingActionButton;
  bool? showNavBar;
  int? selectedIndex;

  /// If set to true, it makes tabs scrollable horizontally
  bool? isScrollable;

  MasterScreenWidget({
    Key? key,
    required this.child,
    this.title,
    this.controller,
    this.onSubmitted,
    this.onClosed,
    this.onChanged,
    this.onCleared,
    this.showBackArrow,
    this.showSearch,
    this.floatingActionButton,
    this.showNavBar = true,
    this.selectedIndex,
    this.isScrollable,
  }) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  bool? removeAppBar;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: _buildNavigationBar(),
      body: Stack(children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.3,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: widget.child!,
        )
      ]),
    );
  }

  ResponsiveNavigationBar? _buildNavigationBar() {
    return (widget.showNavBar == true)
        ? ResponsiveNavigationBar(
            backgroundColor: Color.fromARGB(255, 237, 237, 237),
            backgroundOpacity: 1,
            activeIconColor: Colors.blue,
            inactiveIconColor: Colors.grey,
            fontSize: 25,
            padding: const EdgeInsets.all(2),
            showActiveButtonText: false,
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            outerPadding: const EdgeInsets.all(0),
            borderRadius: 50,
            selectedIndex: (widget.selectedIndex != null)
                ? widget.selectedIndex!
                : _selectedIndex,
            onTabChange: (index) {
              setState(() {
                widget.selectedIndex = index;
                _selectedIndex = index;
              });

              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => HomePage(selectedIndex: index)));
                  break;
                case 1:
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => TrainingPage(selectedIndex: index)));
                  break;
                case 2:
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => ReservationPage(selectedIndex: index)));
                  break;
                case 3:
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => ProfilePage(
                            selectedIndex: index,
                          )));
                  break;
              }
            },
            navigationBarButtons: const <NavigationBarButton>[
              NavigationBarButton(text: 'Početna', icon: Icons.home),
              NavigationBarButton(text: 'Treninzi', icon: Icons.search),
              NavigationBarButton(
                text: 'Rezervacije',
                icon: Icons.check,
                padding: EdgeInsets.all(10),
              ),
              NavigationBarButton(
                text: 'Profil',
                icon: Icons.person,
                padding:
                    EdgeInsets.only(right: 31, left: 10, top: 10, bottom: 10),
              )
            ],
          )
        : null;
  }
}
