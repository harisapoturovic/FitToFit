import 'package:json_annotation/json_annotation.dart';

part 'ocjene.g.dart';

@JsonSerializable()
class Ocjene {
  int ocjenaId;
  DateTime datum;
  int ocjena;
  int korisnikId;
  int trenerId;

  Ocjene(
      {required this.ocjenaId,
      required this.datum,
      required this.ocjena,
      required this.korisnikId,
      required this.trenerId});

  factory Ocjene.fromJson(Map<String, dynamic> json) => _$OcjeneFromJson(json);

  Map<String, dynamic> toJson() => _$OcjeneToJson(this);
}
