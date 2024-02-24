// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novosti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novosti _$NovostiFromJson(Map<String, dynamic> json) => Novosti(
      json['novostId'] as int?,
      json['naslov'] as String?,
      json['sadrzaj'] as String?,
      json['isLiked'] as bool?,
      json['brojLajkova'] as int?,
      json['datumObjave'] == null
          ? null
          : DateTime.parse(json['datumObjave'] as String),
      json['korisnikId'] as int,
      json['vrstaTreningaId'] as int?,
    );

Map<String, dynamic> _$NovostiToJson(Novosti instance) => <String, dynamic>{
      'novostId': instance.novostId,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'isLiked': instance.isLiked,
      'brojLajkova': instance.brojLajkova,
      'datumObjave': instance.datumObjave?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'vrstaTreningaId': instance.vrstaTreningaId,
    };
