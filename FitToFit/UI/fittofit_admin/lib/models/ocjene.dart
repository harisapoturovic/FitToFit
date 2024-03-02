import 'package:json_annotation/json_annotation.dart';

part 'ocjene.g.dart';

@JsonSerializable()
class Ocjene{
  int? ocjenaId;
  DateTime? datum;
  int? ocjena;
  int? korisnikId;
  int? trenerId;

  Ocjene(this.ocjenaId, this.datum, this.ocjena, this.korisnikId, this.trenerId);

  factory Ocjene.fromJson(Map<String, dynamic> json) => _$OcjeneFromJson(json);

  Map<String, dynamic> toJson() => _$OcjeneToJson(this);
}