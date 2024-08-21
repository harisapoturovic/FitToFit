// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnici _$KorisniciFromJson(Map<String, dynamic> json) => Korisnici(
      korisnikId: (json['korisnikId'] as num).toInt(),
      ime: json['ime'] as String,
      prezime: json['prezime'] as String,
      spol: json['spol'] as String,
      telefon: json['telefon'] as String?,
      email: json['email'] as String?,
      adresa: json['adresa'] as String?,
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      datumPocetkaTreniranja: json['datumPocetkaTreniranja'] == null
          ? null
          : DateTime.parse(json['datumPocetkaTreniranja'] as String),
      visina: json['visina'] as String?,
      tezina: json['tezina'] as String?,
      korisnickoIme: json['korisnickoIme'] as String,
      slika: json['slika'] as String?,
      ulogaId: (json['ulogaId'] as num?)?.toInt(),
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
