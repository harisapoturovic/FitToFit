class OcjeneRequest {
  String datum;
  int ocjena;
  int korisnikId;
  int trenerId;

  OcjeneRequest(
      {required this.datum,
      required this.ocjena,
      required this.korisnikId,
      required this.trenerId});

  Map<String, dynamic> toJson() {
    return {
      'datum': datum,
      'ocjena': ocjena,
      'korisnikId': korisnikId,
      'trenerId': trenerId
    };
  }
}
