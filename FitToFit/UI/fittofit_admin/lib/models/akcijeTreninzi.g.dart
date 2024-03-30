// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'akcijeTreninzi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AkcijeTreninzi _$AkcijeTreninziFromJson(Map<String, dynamic> json) =>
    AkcijeTreninzi(
      akcijaTreningId: json['akcijaTreningId'] as int,
      akcijaId: json['akcijaId'] as int,
      treningId: json['treningId'] as int,
      trening: json['trening'] == null
          ? null
          : Treninzi.fromJson(json['trening'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AkcijeTreninziToJson(AkcijeTreninzi instance) =>
    <String, dynamic>{
      'akcijaTreningId': instance.akcijaTreningId,
      'akcijaId': instance.akcijaId,
      'treningId': instance.treningId,
      'trening': instance.trening,
    };
