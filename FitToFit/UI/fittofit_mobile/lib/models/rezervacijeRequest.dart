class RezervacijeRequest {
  String datum;
  int korisnikId;
  int clanarinaId;
  List<RezervacijeItem> items;

  RezervacijeRequest({
    required this.datum,
    required this.korisnikId,
    required this.clanarinaId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'datum': datum,
      'korisnikId': korisnikId,
      'clanarinaId': clanarinaId,
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
