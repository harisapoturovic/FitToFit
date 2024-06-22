// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacijaStavke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RezervacijaStavke _$RezervacijaStavkeFromJson(Map<String, dynamic> json) =>
    RezervacijaStavke(
      rezervacijaStavkeId: json['rezervacijaStavkeId'] as int,
      rezervacijaId: json['rezervacijaId'] as int,
      terminId: json['terminId'] as int,
      termin: json['termin'] == null
          ? null
          : Termini.fromJson(json['termin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezervacijaStavkeToJson(RezervacijaStavke instance) =>
    <String, dynamic>{
      'rezervacijaStavkeId': instance.rezervacijaStavkeId,
      'rezervacijaId': instance.rezervacijaId,
      'terminId': instance.terminId,
      'termin': instance.termin,
    };
