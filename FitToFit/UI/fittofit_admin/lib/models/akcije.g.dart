// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'akcije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Akcije _$AkcijeFromJson(Map<String, dynamic> json) => Akcije(
      akcijaId: json['akcijaId'] as int,
      naziv: json['naziv'] as String,
      datumPocetka: DateTime.parse(json['datumPocetka'] as String),
      datumZavrsetka: DateTime.parse(json['datumZavrsetka'] as String),
      iznos: json['iznos'] as int,
      stateMachine: json['stateMachine'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => AkcijeTreninzi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AkcijeToJson(Akcije instance) => <String, dynamic>{
      'akcijaId': instance.akcijaId,
      'naziv': instance.naziv,
      'datumPocetka': instance.datumPocetka.toIso8601String(),
      'datumZavrsetka': instance.datumZavrsetka.toIso8601String(),
      'iznos': instance.iznos,
      'stateMachine': instance.stateMachine,
      'items': instance.items,
    };
