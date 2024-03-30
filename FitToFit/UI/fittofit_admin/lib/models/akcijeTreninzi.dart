import 'package:fittofit_admin/models/treninzi.dart';
import 'package:json_annotation/json_annotation.dart';

part 'akcijeTreninzi.g.dart';

@JsonSerializable()
class AkcijeTreninzi {
  int akcijaTreningId;
  int akcijaId;
  int treningId;
  Treninzi? trening;

  AkcijeTreninzi(
      {required this.akcijaTreningId,
      required this.akcijaId,
      required this.treningId,
      this.trening});

  factory AkcijeTreninzi.fromJson(Map<String, dynamic> json) =>
      _$AkcijeTreninziFromJson(json);

  Map<String, dynamic> toJson() => _$AkcijeTreninziToJson(this);
}
