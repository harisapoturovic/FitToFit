// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ocjene _$OcjeneFromJson(Map<String, dynamic> json) => Ocjene(
      ocjenaId: json['ocjenaId'] as int,
      datum: DateTime.parse(json['datum'] as String),
      ocjena: json['ocjena'] as int,
      korisnikId: json['korisnikId'] as int,
      trenerId: json['trenerId'] as int,
    );

Map<String, dynamic> _$OcjeneToJson(Ocjene instance) => <String, dynamic>{
      'ocjenaId': instance.ocjenaId,
      'datum': instance.datum.toIso8601String(),
      'ocjena': instance.ocjena,
      'korisnikId': instance.korisnikId,
      'trenerId': instance.trenerId,
    };
