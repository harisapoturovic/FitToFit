// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrste_treninga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VrsteTreninga _$VrsteTreningaFromJson(Map<String, dynamic> json) =>
    VrsteTreninga(
      json['vrstaTreningaId'] as int?,
      json['naziv'] as String?,
      json['opis'] as String?,
    );

Map<String, dynamic> _$VrsteTreningaToJson(VrsteTreninga instance) =>
    <String, dynamic>{
      'vrstaTreningaId': instance.vrstaTreningaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
    };
