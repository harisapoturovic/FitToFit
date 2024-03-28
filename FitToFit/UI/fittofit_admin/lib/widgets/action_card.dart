import 'package:fittofit_admin/models/akcije.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AkcijeCard extends StatelessWidget {
  final Akcije akcija;

  const AkcijeCard({Key? key, required this.akcija}) : super(key: key);

  String formatDate(DateTime? dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRect(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                  width: 250.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      width: 130.0, 
                      height: 130.0, 
                      child: Image.asset(
                        'assets/images/popust.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${akcija.naziv != null && akcija.naziv.length > 20 ? akcija.naziv.substring(0, 20) + '...' : akcija.naziv}',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 90, 90, 90)),
              ),
              SizedBox(height: 8),
              Text(
                '${formatDate(akcija.datumPocetka) + ' - ' + formatDate(akcija.datumZavrsetka)}',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
  }
}
