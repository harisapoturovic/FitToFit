// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termini.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Termini _$TerminiFromJson(Map<String, dynamic> json) => Termini(
      terminId: (json['terminId'] as num).toInt(),
      dan: json['dan'] as String,
      sat: json['sat'] as String?,
      brojClanova: (json['brojClanova'] as num).toInt(),
      treningId: (json['treningId'] as num).toInt(),
      trenerId: (json['trenerId'] as num).toInt(),
      salaId: (json['salaId'] as num).toInt(),
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
