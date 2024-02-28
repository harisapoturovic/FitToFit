import 'dart:io';

import 'package:fittofit_admin/models/korisnici.dart';
import 'package:fittofit_admin/models/novosti.dart';
import 'package:fittofit_admin/models/search_result.dart';
import 'package:fittofit_admin/models/vrste_treninga.dart';
import 'package:fittofit_admin/providers/korisnici_provider.dart';
import 'package:fittofit_admin/providers/novosti_provider.dart';
import 'package:fittofit_admin/providers/treneri_provider.dart';
import 'package:fittofit_admin/providers/vrste_treninga_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/treneri.dart';
import '../widgets/master_screen.dart';

class KorisniciPage extends StatefulWidget {
  const KorisniciPage({Key? key}) : super(key: key);

  @override
  State<KorisniciPage> createState() => _KorisniciPageState();
}

class _KorisniciPageState extends State<KorisniciPage> {
  late KorisniciProvider _korisniciProvider;
  late TreneriProvider _treneriProvider;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Treneri>? treneriResult;
  TextEditingController _treneriController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _treneriProvider = context.read<TreneriProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.only(left: 130.0, right: 130.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ime/prezime',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 30.0),
                Expanded(
                  child: userList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.only(left: 130.0, right: 130.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ime/prezime',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 30.0),
                Expanded(
                  child: trainerList(),
                ),
              ],
            ),
          ),
        ],
      ),
      title: "Korisnici & treneri",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(0, 154, 231, 1),
      ),
    );
  }

  Widget userList() {
    List<String> users = ['User 1', 'User 2', 'User 3'];

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 245, 251, 1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin:
          EdgeInsets.only(left: 130.0, right: 130.0, top: 50.0, bottom: 50.0),
      padding: EdgeInsets.all(50.0),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 50.0), 
            leading: Icon(
              Icons.person, // ZAMIJENITI SA SLIKOM KORISNIKA
              color: Color.fromRGBO(0, 135, 202, 1),
              size: 30.0,
            ),
            title: Text(
              users[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Color.fromRGBO(0, 135, 202, 1),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget trainerList() {
    List<String> trainers = ['Trainer A', 'Trainer B', 'Trainer C'];

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 245, 251, 1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin:
          EdgeInsets.only(left: 130.0, right: 130.0, top: 50.0, bottom: 50.0),
      padding: EdgeInsets.all(50.0),
      child: ListView.builder(
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 50.0), 
            leading: Icon(
              Icons.person, // ZAMIJENITI SA SLIKOM TRENERA
              color: Color.fromRGBO(0, 135, 202, 1),
              size: 30.0,
            ),
            title: Text(
              trainers[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Color.fromRGBO(0, 135, 202, 1),
              ),
            ),
          );
        },
      ),
    );
  }
}
