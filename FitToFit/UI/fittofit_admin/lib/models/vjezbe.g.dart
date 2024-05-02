// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vjezbe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vjezbe _$VjezbeFromJson(Map<String, dynamic> json) => Vjezbe(
      vjezbaId: json['vjezbaId'] as int,
      naziv: json['naziv'] as String,
      opis: json['opis'] as String?,
      slika: json['slika'] as String?,
      treninziVjezbes: (json['treninziVjezbes'] as List<dynamic>?)
          ?.map((e) => VjezbeTreninzi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VjezbeToJson(Vjezbe instance) => <String, dynamic>{
      'vjezbaId': instance.vjezbaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'slika': instance.slika,
      'treninziVjezbes': instance.treninziVjezbes,
    };
