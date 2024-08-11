import 'package:fittofit_admin/models/acTrening.dart';
import 'package:fittofit_admin/models/treninzi.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AcTreningProvider with ChangeNotifier {
  AcTrening acTrening = AcTrening();

  addToAc(Treninzi trening) {
    AcTrening newAcTrening = AcTrening();
    newAcTrening.items.add(AcTreningItem(trening));
    acTrening = newAcTrening;
    notifyListeners();
  }
}
