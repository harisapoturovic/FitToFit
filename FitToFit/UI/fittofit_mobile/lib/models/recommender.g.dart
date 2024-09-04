// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommender _$RecommenderFromJson(Map<String, dynamic> json) => Recommender(
      id: (json['id'] as num?)?.toInt(),
      treningId: (json['treningId'] as num?)?.toInt(),
      coTreningId1: (json['coTreningId1'] as num?)?.toInt(),
      coTreningId2: (json['coTreningId2'] as num?)?.toInt(),
      coTreningId3: (json['coTreningId3'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecommenderToJson(Recommender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'treningId': instance.treningId,
      'coTreningId1': instance.coTreningId1,
      'coTreningId2': instance.coTreningId2,
      'coTreningId3': instance.coTreningId3,
    };
