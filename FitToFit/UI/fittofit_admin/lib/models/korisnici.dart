import 'package:json_annotation/json_annotation.dart';

part 'korisnici.g.dart';

@JsonSerializable()
class Korisnici{
  int? korisnikId;
  String? ime;
  String? prezime;
  String? spol;
  String? telefon;
  String? email;
  String? adresa;
  DateTime? datumRodjenja;
  DateTime? datumPocetkaTreniranja;
  String? visina;
  String? tezina;
  String? korisnickoIme;
  String? slika;
  int? ulogaId;

  Korisnici(this.korisnikId, this.ime, this.prezime, this.spol, this.telefon, this.email, this.adresa, this.datumRodjenja, 
  this.datumPocetkaTreniranja, this.visina, this.tezina, this.korisnickoIme, this.slika, this.ulogaId);

  factory Korisnici.fromJson(Map<String, dynamic> json) => _$KorisniciFromJson(json);

  Map<String, dynamic> toJson() => _$KorisniciToJson(this);
}