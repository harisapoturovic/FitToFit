import 'package:fittofit_admin/models/termini.dart';
import 'package:fittofit_admin/models/vjezbeTreninzi.dart';
import 'package:json_annotation/json_annotation.dart';

part 'treninzi.g.dart';

@JsonSerializable()
class Treninzi {
  int treningId;
  String naziv;
  String opis;
  int maxBrojClanova;
  double cijenaPoTerminu;
  String trajanje;
  double prosjecnaPotrosnjaKalorija;
  int vrstaId;
  String namjena;
  String? slika;
  List<Termini> terminis = [];
  List<VjezbeTreninzi>? treninziVjezbes = [];

  Treninzi(
      {required this.treningId,
      required this.naziv,
      required this.opis,
      required this.maxBrojClanova,
      required this.cijenaPoTerminu,
      required this.trajanje,
      required this.prosjecnaPotrosnjaKalorija,
      required this.vrstaId,
      required this.namjena,
      this.slika,
      required this.terminis,
      this.treninziVjezbes});

  factory Treninzi.fromJson(Map<String, dynamic> json) =>
      _$TreninziFromJson(json);

  Map<String, dynamic> toJson() => _$TreninziToJson(this);
}
