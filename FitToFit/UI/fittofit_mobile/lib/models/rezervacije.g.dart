// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacije _$RezervacijeFromJson(Map<String, dynamic> json) => Rezervacije(
      rezervacijaId: json['rezervacijaId'] as int,
      datum: DateTime.parse(json['datum'] as String),
      stateMachine: json['stateMachine'] as String?,
      iznos: (json['iznos'] as num?)?.toDouble(),
      korisnikId: json['korisnikId'] as int,
      clanarinaId: json['clanarinaId'] as int,
      datumIsteka: json['datumIsteka'] != null ? DateTime.parse(json['datumIsteka'] as String) : null,
      rezervacijaStavkes: (json['rezervacijaStavkes'] as List<dynamic>?)
          ?.map((e) => RezervacijaStavke.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RezervacijeToJson(Rezervacije instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'datum': instance.datum.toIso8601String(),
      'stateMachine': instance.stateMachine,
      'iznos': instance.iznos,
      'korisnikId': instance.korisnikId,
      'clanarinaId': instance.clanarinaId,
      'datumIsteka': instance.datumIsteka?.toIso8601String(),
      'rezervacijaStavkes': instance.rezervacijaStavkes,
    };
