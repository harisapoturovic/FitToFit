// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'treninziClanarine.g.dart';

@JsonSerializable()
class TreninziClanarine {
  int treningClanarinaId;
  int? cijena;
  int? ucestalost;
  int clanarinaId;
  int vrstaTreningaId;

  TreninziClanarine(
      {required this.treningClanarinaId,
      this.cijena,
      this.ucestalost,
      required this.vrstaTreningaId,
      required this.clanarinaId});

  factory TreninziClanarine.fromJson(Map<String, dynamic> json) =>
      _$TreninziClanarineFromJson(json);

  Map<String, dynamic> toJson() => _$TreninziClanarineToJson(this);
}
