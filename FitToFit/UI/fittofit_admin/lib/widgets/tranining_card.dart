import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/pages/treninzi_detalji.dart';
import 'package:fittofit_admin/utils/util.dart';
import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  final Treninzi training;

  const TrainingCard({Key? key, required this.training}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRect(
            child: training.slika != null && training.slika != ''
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    child: Container(
                      width: 300.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: imageFromBase64String(training.slika!).image,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    child: Container(
                        width: 300.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/images/training.jpg',
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  training.naziv.length > 20
                      ? '${training.naziv.substring(0, 20)}...'
                      : training.naziv,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 99, 181)),
                ),
                const SizedBox(height: 8),
                Text(
                  training.opis.length > 30
                      ? '${training.opis.substring(0, 30)}...'
                      : training.opis,
                  style: const TextStyle(
                      fontSize: 16.0, color: Color.fromARGB(255, 0, 99, 181)),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TreninziDetaljiPage(trening: training),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 33, 65, 243),
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  child: const Text('Detalji'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
