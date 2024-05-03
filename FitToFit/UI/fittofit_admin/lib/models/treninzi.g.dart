// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treninzi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Treninzi _$TreninziFromJson(Map<String, dynamic> json) => Treninzi(
      treningId: json['treningId'] as int,
      naziv: json['naziv'] as String,
      opis: json['opis'] as String,
      maxBrojClanova: json['maxBrojClanova'] as int,
      cijenaPoTerminu: (json['cijenaPoTerminu'] as num).toDouble(),
      trajanje: json['trajanje'] as String,
      prosjecnaPotrosnjaKalorija:
          (json['prosjecnaPotrosnjaKalorija'] as num).toDouble(),
      vrstaId: json['vrstaId'] as int,
      namjena: json['namjena'] as String,
      slika: json['slika'] as String?,
      terminis: (json['terminis'] as List<dynamic>)
          .map((e) => Termini.fromJson(e as Map<String, dynamic>))
          .toList(),
      treninziVjezbes: (json['treninziVjezbes'] as List<dynamic>?)
          ?.map((e) => VjezbeTreninzi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TreninziToJson(Treninzi instance) => <String, dynamic>{
      'treningId': instance.treningId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'maxBrojClanova': instance.maxBrojClanova,
      'cijenaPoTerminu': instance.cijenaPoTerminu,
      'trajanje': instance.trajanje,
      'prosjecnaPotrosnjaKalorija': instance.prosjecnaPotrosnjaKalorija,
      'vrstaId': instance.vrstaId,
      'namjena': instance.namjena,
      'slika': instance.slika,
      'terminis': instance.terminis,
      'treninziVjezbes': instance.treninziVjezbes,
    };
