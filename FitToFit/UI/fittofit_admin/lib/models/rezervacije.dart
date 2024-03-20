import 'package:json_annotation/json_annotation.dart';

part 'rezervacije.g.dart';

@JsonSerializable()
class Rezervacije {
  int rezervacijaId;
  DateTime datum;
  String? stateMachine;
  int? iznos;
  int korisnikId;
  int clanarinaId;

  Rezervacije(
      {required this.rezervacijaId,
      required this.datum,
      this.stateMachine,
      this.iznos,
      required this.korisnikId,
      required this.clanarinaId});

  factory Rezervacije.fromJson(Map<String, dynamic> json) =>
      _$RezervacijeFromJson(json);

  Map<String, dynamic> toJson() => _$RezervacijeToJson(this);
}
