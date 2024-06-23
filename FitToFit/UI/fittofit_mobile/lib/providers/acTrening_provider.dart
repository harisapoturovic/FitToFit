// ignore_for_file: file_names

import 'package:fittofit_mobile/models/acTrening.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
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
/*
  AcTreningItem? findInAc(Treninzi trening) {
    AcTreningItem? item = acTrening.items
        .firstWhere((item) => item.trening.treningId == trening.treningId);
    return item;
  }*/
}
