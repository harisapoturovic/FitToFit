// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termini.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Termini _$TerminiFromJson(Map<String, dynamic> json) => Termini(
      terminId: json['terminId'] as int,
      dan: json['dan'] as String,
      sat: json['sat'] as String?,
      brojClanova: json['brojClanova'] as int,
      treningId: json['treningId'] as int,
      trenerId: json['trenerId'] as int,
      salaId: json['salaId'] as int,
    );

Map<String, dynamic> _$TerminiToJson(Termini instance) => <String, dynamic>{
      'terminId': instance.terminId,
      'dan': instance.dan,
      'sat': instance.sat,
      'brojClanova': instance.brojClanova,
      'treningId': instance.treningId,
      'trenerId': instance.trenerId,
      'salaId': instance.salaId,
    };
