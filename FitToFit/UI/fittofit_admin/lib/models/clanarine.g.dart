// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clanarine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clanarine _$ClanarineFromJson(Map<String, dynamic> json) => Clanarine(
      clanarinaId: (json['clanarinaId'] as num).toInt(),
      naziv: json['naziv'] as String,
      rezervacijes: (json['rezervacijes'] as List<dynamic>?)
          ?.map((e) => Rezervacije.fromJson(e as Map<String, dynamic>))
          .toList(),
      treninziClanarines: (json['treninziClanarines'] as List<dynamic>?)
          ?.map((e) => TreninziClanarine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClanarineToJson(Clanarine instance) => <String, dynamic>{
      'clanarinaId': instance.clanarinaId,
      'naziv': instance.naziv,
      'rezervacijes': instance.rezervacijes,
      'treninziClanarines': instance.treninziClanarines,
    };
