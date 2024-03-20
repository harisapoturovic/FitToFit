import 'package:json_annotation/json_annotation.dart';

import 'ocjene.dart';

part 'treneri.g.dart';

@JsonSerializable()
class Treneri {
  int trenerId;
  String ime;
  String prezime;
  String spol;
  String? telefon;
  String? email;
  String? adresa;
  DateTime datumZaposlenja;
  String? zvanje;
  String? slika;
  List<Ocjene>? ocjene;

  Treneri(
      {required this.trenerId,
      required this.ime,
      required this.prezime,
      required this.spol,
      this.telefon,
      this.email,
      this.adresa,
      required this.datumZaposlenja,
      this.zvanje,
      this.slika,
      this.ocjene});

  factory Treneri.fromJson(Map<String, dynamic> json) =>
      _$TreneriFromJson(json);

  Map<String, dynamic> toJson() => _$TreneriToJson(this);
}
