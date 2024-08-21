// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treninziClanarine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreninziClanarine _$TreninziClanarineFromJson(Map<String, dynamic> json) =>
    TreninziClanarine(
      treningClanarinaId: (json['treningClanarinaId'] as num).toInt(),
      cijena: (json['cijena'] as num?)?.toInt(),
      ucestalost: (json['ucestalost'] as num?)?.toInt(),
      vrstaTreningaId: (json['vrstaTreningaId'] as num).toInt(),
      clanarinaId: (json['clanarinaId'] as num).toInt(),
    );

Map<String, dynamic> _$TreninziClanarineToJson(TreninziClanarine instance) =>
    <String, dynamic>{
      'treningClanarinaId': instance.treningClanarinaId,
      'cijena': instance.cijena,
      'ucestalost': instance.ucestalost,
      'clanarinaId': instance.clanarinaId,
      'vrstaTreningaId': instance.vrstaTreningaId,
    };
