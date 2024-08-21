// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacije _$RezervacijeFromJson(Map<String, dynamic> json) => Rezervacije(
      rezervacijaId: (json['rezervacijaId'] as num).toInt(),
      datum: DateTime.parse(json['datum'] as String),
      stateMachine: json['stateMachine'] as String?,
      iznos: (json['iznos'] as num?)?.toDouble(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      clanarinaId: (json['clanarinaId'] as num).toInt(),
      brojTransakcije: json['brojTransakcije'] as String?,
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
      'brojTransakcije': instance.brojTransakcije,
      'rezervacijaStavkes': instance.rezervacijaStavkes,
    };
