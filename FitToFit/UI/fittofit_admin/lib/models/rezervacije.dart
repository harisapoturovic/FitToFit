import 'package:fittofit_admin/models/rezervacijaStavke.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rezervacije.g.dart';

@JsonSerializable()
class Rezervacije {
  int rezervacijaId;
  DateTime datum;
  String? stateMachine;
  double? iznos;
  int korisnikId;
  int clanarinaId;
  String? brojTransakcije;
  List<RezervacijaStavke>? rezervacijaStavkes = [];

  Rezervacije(
      {required this.rezervacijaId,
      required this.datum,
      this.stateMachine,
      this.iznos,
      required this.korisnikId,
      required this.clanarinaId,
      this.brojTransakcije,
      this.rezervacijaStavkes});

  factory Rezervacije.fromJson(Map<String, dynamic> json) =>
      _$RezervacijeFromJson(json);

  Map<String, dynamic> toJson() => _$RezervacijeToJson(this);
}
