// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novosti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novosti _$NovostiFromJson(Map<String, dynamic> json) => Novosti(
      novostId: (json['novostId'] as num).toInt(),
      naslov: json['naslov'] as String,
      sadrzaj: json['sadrzaj'] as String?,
      isLiked: json['isLiked'] as bool?,
      brojLajkova: (json['brojLajkova'] as num).toInt(),
      datumObjave: DateTime.parse(json['datumObjave'] as String),
      korisnikId: (json['korisnikId'] as num).toInt(),
      vrstaTreningaId: (json['vrstaTreningaId'] as num?)?.toInt(),
      isRead: json['isRead'] as bool?,
    );

Map<String, dynamic> _$NovostiToJson(Novosti instance) => <String, dynamic>{
      'novostId': instance.novostId,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'isLiked': instance.isLiked,
      'brojLajkova': instance.brojLajkova,
      'datumObjave': instance.datumObjave.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'vrstaTreningaId': instance.vrstaTreningaId,
      'isRead': instance.isRead,
    };
