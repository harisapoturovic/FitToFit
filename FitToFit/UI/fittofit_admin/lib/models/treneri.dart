import 'package:json_annotation/json_annotation.dart';

part 'treneri.g.dart';

@JsonSerializable()
class Treneri{
  int? trenerId;
  String? ime;
  String? prezime;
  String? spol;
  String? telefon;
  String? email;
  String? adresa;
  DateTime? datumZaposlenja;
  String? zvanje;
  String? slika;

  Treneri(this.trenerId, this.ime, this.prezime, this.spol, this.telefon, this.email, this.adresa, this.datumZaposlenja, 
  this.zvanje, this.slika);

  factory Treneri.fromJson(Map<String, dynamic> json) => _$TreneriFromJson(json);

  Map<String, dynamic> toJson() => _$TreneriToJson(this);
}