class TreninziUpdateRequest {
  String opis;
  int maxBrojClanova;
  double cijenaPoTerminu;
  String trajanje;
  double prosjecnaPotrosnjaKalorija;
  int vrstaId;
  String namjena;
  String? slika;

  TreninziUpdateRequest(
      {required this.opis,
      required this.maxBrojClanova,
      required this.cijenaPoTerminu,
      required this.trajanje,
      required this.prosjecnaPotrosnjaKalorija,
      required this.vrstaId,
      required this.namjena,
      this.slika});

  Map<String, dynamic> toJson() {
    return {
      'opis': opis,
      'maxBrojClanova': maxBrojClanova,
      'cijenaPoTerminu': cijenaPoTerminu,
      'trajanje': trajanje,
      'prosjecnaPotrosnjaKalorija': prosjecnaPotrosnjaKalorija,
      'vrstaId': vrstaId,
      'namjena': namjena,
      'slika': slika,
    };
  }
}
