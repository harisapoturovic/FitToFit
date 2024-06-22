import 'package:fittofit_admin/models/treninzi.dart';

class AcTrening {
  List<AcTreningItem> items = [];
  String naziv = '';
  DateTime datumPocetka = DateTime.now();
  DateTime datumZavrsetka = DateTime.now();
  int iznos = 0;

  factory AcTrening() => AcTrening._();

  AcTrening._();

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'naziv': naziv,
      'datumPocetka': datumPocetka,
      'datumZavrsetka': datumZavrsetka,
      'iznos': iznos
    };
  }

  AcTrening.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List<dynamic>)
        .map((itemData) => AcTreningItem.fromJson(itemData))
        .toList();
    naziv = json['naziv'];
    datumPocetka = json['datumPocetka'];
    datumZavrsetka = json['datumZavrsetka'];
    iznos = json['iznos'];
  }
}

class AcTreningItem {
  late Treninzi trening;
  AcTreningItem(this.trening);

  Map<String, dynamic> toJson() {
    return {'trening': trening.toJson()};
  }

  AcTreningItem.fromJson(Map<String, dynamic> json) {
    trening = Treninzi.fromJson(json['trening']);
  }
}
