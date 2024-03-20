// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacije _$RezervacijeFromJson(Map<String, dynamic> json) => Rezervacije(
      rezervacijaId: json['rezervacijaId'] as int,
      datum: DateTime.parse(json['datum'] as String),
      stateMachine: json['stateMachine'] as String?,
      iznos: json['iznos'] as int?,
      korisnikId: json['korisnikId'] as int,
      clanarinaId: json['clanarinaId'] as int,
    );

Map<String, dynamic> _$RezervacijeToJson(Rezervacije instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'datum': instance.datum.toIso8601String(),
      'stateMachine': instance.stateMachine,
      'iznos': instance.iznos,
      'korisnikId': instance.korisnikId,
      'clanarinaId': instance.clanarinaId,
    };
