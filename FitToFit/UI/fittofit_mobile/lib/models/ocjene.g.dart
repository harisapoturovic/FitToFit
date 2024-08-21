// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ocjene _$OcjeneFromJson(Map<String, dynamic> json) => Ocjene(
      ocjenaId: (json['ocjenaId'] as num).toInt(),
      datum: DateTime.parse(json['datum'] as String),
      ocjena: (json['ocjena'] as num).toInt(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      trenerId: (json['trenerId'] as num).toInt(),
    );

Map<String, dynamic> _$OcjeneToJson(Ocjene instance) => <String, dynamic>{
      'ocjenaId': instance.ocjenaId,
      'datum': instance.datum.toIso8601String(),
      'ocjena': instance.ocjena,
      'korisnikId': instance.korisnikId,
      'trenerId': instance.trenerId,
    };
