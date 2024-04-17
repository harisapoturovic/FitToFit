// ignore_for_file: file_names

import 'package:fittofit_admin/models/termini.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rezervacijaStavke.g.dart';

@JsonSerializable()
class RezervacijaStavke {
  int rezervacijaStavkeId;
  int rezervacijaId;
  int terminId;
  Termini? termin;

  RezervacijaStavke(
      {required this.rezervacijaStavkeId,
      required this.rezervacijaId,
      required this.terminId,
      this.termin});

  factory RezervacijaStavke.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaStavkeFromJson(json);

  Map<String, dynamic> toJson() => _$RezervacijaStavkeToJson(this);
}
