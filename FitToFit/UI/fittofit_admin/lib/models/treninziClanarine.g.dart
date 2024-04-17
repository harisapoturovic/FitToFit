// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treninziClanarine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreninziClanarine _$TreninziClanarineFromJson(Map<String, dynamic> json) =>
    TreninziClanarine(
      treningClanarinaId: json['treningClanarinaId'] as int,
      cijena: json['cijena'] as int,
      ucestalost: json['ucestalost'] as int?,
      vrstaTreningaId: json['vrstaTreningaId'] as int,
      clanarinaId: json['clanarinaId'] as int,
    );

Map<String, dynamic> _$TreninziClanarineToJson(TreninziClanarine instance) =>
    <String, dynamic>{
      'treningClanarinaId': instance.treningClanarinaId,
      'cijena': instance.cijena,
      'ucestalost': instance.ucestalost,
      'clanarinaId': instance.clanarinaId,
      'vrstaTreningaId': instance.vrstaTreningaId,
    };
