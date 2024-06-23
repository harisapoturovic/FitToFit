import 'package:fittofit_mobile/models/rezervacije.dart';
import 'package:fittofit_mobile/models/treninziClanarine.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clanarine.g.dart';

@JsonSerializable()
class Clanarine {
  int clanarinaId;
  String naziv;
  List<Rezervacije>? rezervacijes = [];
  List<TreninziClanarine>? treninziClanarines = [];

  Clanarine(
      {required this.clanarinaId,
      required this.naziv,
      this.rezervacijes,
      this.treninziClanarines});

  factory Clanarine.fromJson(Map<String, dynamic> json) =>
      _$ClanarineFromJson(json);

  Map<String, dynamic> toJson() => _$ClanarineToJson(this);
}
