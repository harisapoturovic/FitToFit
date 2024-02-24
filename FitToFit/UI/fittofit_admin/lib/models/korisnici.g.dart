// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnici _$KorisniciFromJson(Map<String, dynamic> json) => Korisnici(
      json['korisnikId'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['spol'] as String?,
      json['telefon'] as String?,
      json['email'] as String?,
      json['adresa'] as String?,
      json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      json['datumPocetkaTreniranja'] == null
          ? null
          : DateTime.parse(json['datumPocetkaTreniranja'] as String),
      json['visina'] as String?,
      json['tezina'] as String?,
      json['korisnickoIme'] as String?,
      json['slika'] as String?,
      json['ulogaId'] as int?,
    );

Map<String, dynamic> _$KorisniciToJson(Korisnici instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'spol': instance.spol,
      'telefon': instance.telefon,
      'email': instance.email,
      'adresa': instance.adresa,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'datumPocetkaTreniranja':
          instance.datumPocetkaTreniranja?.toIso8601String(),
      'visina': instance.visina,
      'tezina': instance.tezina,
      'korisnickoIme': instance.korisnickoIme,
      'slika': instance.slika,
      'ulogaId': instance.ulogaId,
    };
