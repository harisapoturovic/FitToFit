// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treneri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Treneri _$TreneriFromJson(Map<String, dynamic> json) => Treneri(
      trenerId: json['trenerId'] as int,
      ime: json['ime'] as String,
      prezime: json['prezime'] as String,
      spol: json['spol'] as String,
      telefon: json['telefon'] as String?,
      email: json['email'] as String?,
      adresa: json['adresa'] as String?,
      datumZaposlenja: DateTime.parse(json['datumZaposlenja'] as String),
      zvanje: json['zvanje'] as String?,
      slika: json['slika'] as String?,
      ocjenes: (json['ocjenes'] as List<dynamic>?)
          ?.map((e) => Ocjene.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TreneriToJson(Treneri instance) => <String, dynamic>{
      'trenerId': instance.trenerId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'spol': instance.spol,
      'telefon': instance.telefon,
      'email': instance.email,
      'adresa': instance.adresa,
      'datumZaposlenja': instance.datumZaposlenja.toIso8601String(),
      'zvanje': instance.zvanje,
      'slika': instance.slika,
      'ocjenes': instance.ocjenes,
    };
