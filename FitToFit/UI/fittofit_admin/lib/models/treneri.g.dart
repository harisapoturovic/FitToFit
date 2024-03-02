// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treneri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Treneri _$TreneriFromJson(Map<String, dynamic> json) => Treneri(
      json['trenerId'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['spol'] as String?,
      json['telefon'] as String?,
      json['email'] as String?,
      json['adresa'] as String?,
      json['datumZaposlenja'] == null
          ? null
          : DateTime.parse(json['datumZaposlenja'] as String),
      json['zvanje'] as String?,
      json['slika'] as String?,
      (json['ocjene'] as List<dynamic>?)
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
      'datumZaposlenja': instance.datumZaposlenja?.toIso8601String(),
      'zvanje': instance.zvanje,
      'slika': instance.slika,
      'ocjene': instance.ocjene,
    };
