// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sale _$SaleFromJson(Map<String, dynamic> json) => Sale(
      salaId: json['salaId'] as int,
      naziv: json['naziv'] as String,
      velicina: json['velicina'] as String?,
      slika: json['slika'] as String?,
      terminis: (json['terminis'] as List<dynamic>?)
          ?.map((e) => Termini.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
      'salaId': instance.salaId,
      'naziv': instance.naziv,
      'velicina': instance.velicina,
      'slika': instance.slika,
      'terminis': instance.terminis,
    };
