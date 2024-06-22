// ignore_for_file: file_names

import 'package:fittofit_admin/models/treninzi.dart';
import 'package:fittofit_admin/models/vjezbe.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vjezbeTreninzi.g.dart';

@JsonSerializable()
class VjezbeTreninzi {
  int treningVjezbaId;
  double trajanje;
  int vjezbaId;
  int treningId;
  Treninzi? trening;
  Vjezbe? vjezba;

  VjezbeTreninzi(
      {required this.treningVjezbaId,
      required this.trajanje,
      required this.vjezbaId,
      required this.treningId,
      this.trening,
      this.vjezba});

  factory VjezbeTreninzi.fromJson(Map<String, dynamic> json) =>
      _$VjezbeTreninziFromJson(json);

  Map<String, dynamic> toJson() => _$VjezbeTreninziToJson(this);
}
