import 'package:json_annotation/json_annotation.dart';

part 'novosti.g.dart';

@JsonSerializable()
@JsonKey(name: 'isLiked')
class Novosti{
  int? novostId;
  String? naslov;
  String? sadrzaj;
  bool? isLiked;
  int? brojLajkova;
  DateTime? datumObjave;
  int korisnikId;
  int? vrstaTreningaId;

  Novosti(this.novostId, this.naslov, this.sadrzaj, this.isLiked, this.brojLajkova, this.datumObjave, this.korisnikId, this.vrstaTreningaId);

  factory Novosti.fromJson(Map<String, dynamic> json) => _$NovostiFromJson(json);

  Map<String, dynamic> toJson() => _$NovostiToJson(this);
}