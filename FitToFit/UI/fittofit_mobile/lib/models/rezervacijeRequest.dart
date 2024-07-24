class RezervacijeRequest {
  String datum;
  int korisnikId;
  int clanarinaId;
  int? iznos;
  List<RezervacijeItem> items;

  RezervacijeRequest({
    required this.datum,
    required this.korisnikId,
    required this.clanarinaId,
    this.iznos,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'datum': datum,
      'korisnikId': korisnikId,
      'clanarinaId': clanarinaId,
      'iznos': iznos,
      'items': items.map((item) => item.toJson()).toList(),
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
