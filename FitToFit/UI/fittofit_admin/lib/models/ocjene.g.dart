// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ocjene _$OcjeneFromJson(Map<String, dynamic> json) => Ocjene(
      json['ocjenaId'] as int?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['ocjena'] as int?,
      json['korisnikId'] as int?,
      json['trenerId'] as int?,
    );

Map<String, dynamic> _$OcjeneToJson(Ocjene instance) => <String, dynamic>{
      'ocjenaId': instance.ocjenaId,
      'datum': instance.datum?.toIso8601String(),
      'ocjena': instance.ocjena,
      'korisnikId': instance.korisnikId,
      'trenerId': instance.trenerId,
    };
