import 'package:json_annotation/json_annotation.dart';

part 'akcijeTreninzi.g.dart';

@JsonSerializable()
class AkcijeTreninzi {
  int akcijaTreningId;
  int akcijaId;
  int treningId;

  AkcijeTreninzi(
      {required this.akcijaTreningId,
      required this.akcijaId,
      required this.treningId});

  factory AkcijeTreninzi.fromJson(Map<String, dynamic> json) =>
      _$AkcijeTreninziFromJson(json);

  Map<String, dynamic> toJson() => _$AkcijeTreninziToJson(this);
}
