class RezervacijeRequest {
  String datum;
  int korisnikId;
  int clanarinaId;
  double? iznos;
  String datumIsteka;
  String? brojTransakcije;
  List<RezervacijeItem> items;

  RezervacijeRequest({
    required this.datum,
    required this.korisnikId,
    required this.clanarinaId,
    this.iznos,
    required this.items,
    required this.datumIsteka,
    this.brojTransakcije
  });

  Map<String, dynamic> toJson() {
    return {
      'datum': datum,
      'korisnikId': korisnikId,
      'clanarinaId': clanarinaId,
      'iznos': iznos,
      'items': items.map((item) => item.toJson()).toList(),
      'datumIsteka': datumIsteka,
      'brojTransakcije': brojTransakcije,
    };
  }
}

class RezervacijeItem {
  int terminId;

  RezervacijeItem({required this.terminId});

  Map<String, dynamic> toJson() {
    return {
      'terminId': terminId,
    };
  }
}
