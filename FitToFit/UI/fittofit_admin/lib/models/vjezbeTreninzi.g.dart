// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vjezbeTreninzi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VjezbeTreninzi _$VjezbeTreninziFromJson(Map<String, dynamic> json) =>
    VjezbeTreninzi(
      treningVjezbaId: json['treningVjezbaId'] as int,
      trajanje: (json['trajanje'] as num).toDouble(),
      vjezbaId: json['vjezbaId'] as int,
      treningId: json['treningId'] as int,
      trening: json['trening'] == null
          ? null
          : Treninzi.fromJson(json['trening'] as Map<String, dynamic>),
      vjezba: json['vjezba'] == null
          ? null
          : Vjezbe.fromJson(json['vjezba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VjezbeTreninziToJson(VjezbeTreninzi instance) =>
    <String, dynamic>{
      'treningVjezbaId': instance.treningVjezbaId,
      'trajanje': instance.trajanje,
      'vjezbaId': instance.vjezbaId,
      'treningId': instance.treningId,
      'trening': instance.trening,
      'vjezba': instance.vjezba,
    };
