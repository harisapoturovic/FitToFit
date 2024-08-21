// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisniciNovosti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisniciNovosti _$KorisniciNovostiFromJson(Map<String, dynamic> json) =>
    KorisniciNovosti(
      korisniciNovostiId: (json['korisniciNovostiId'] as num).toInt(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      novostId: (json['novostId'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$KorisniciNovostiToJson(KorisniciNovosti instance) =>
    <String, dynamic>{
      'korisniciNovostiId': instance.korisniciNovostiId,
      'korisnikId': instance.korisnikId,
      'novostId': instance.novostId,
      'isLiked': instance.isLiked,
      'isRead': instance.isRead,
    };
