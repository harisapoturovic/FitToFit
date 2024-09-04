import 'package:json_annotation/json_annotation.dart';
part 'recommender.g.dart';

@JsonSerializable()
class Recommender {
  int? id;
  int? treningId;
  int? coTreningId1;
  int? coTreningId2;
  int? coTreningId3;

  Recommender(
      {this.id,
      this.treningId,
      this.coTreningId1,
      this.coTreningId2,
      this.coTreningId3});

  factory Recommender.fromJson(Map<String, dynamic> json) =>
      _$RecommenderFromJson(json);

  Map<String, dynamic> toJson() => _$RecommenderToJson(this);
}
