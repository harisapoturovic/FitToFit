import 'package:json_annotation/json_annotation.dart';

part 'termini.g.dart';

@JsonSerializable()
class Termini {
  int terminId;
  String dan;
  String? sat;
  int brojClanova;
  int treningId;
  int trenerId;
  int salaId;

  Termini(
      {required this.terminId,
      required this.dan,
      this.sat,
      required this.brojClanova,
      required this.treningId,
      required this.trenerId,
      required this.salaId});

  factory Termini.fromJson(Map<String, dynamic> json) =>
      _$TerminiFromJson(json);

  Map<String, dynamic> toJson() => _$TerminiToJson(this);
}
