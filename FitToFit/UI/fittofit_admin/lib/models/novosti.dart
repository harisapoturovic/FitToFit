import 'package:json_annotation/json_annotation.dart';

part 'novosti.g.dart';

@JsonSerializable()
// ignore: invalid_annotation_target
@JsonKey(name: 'isLiked')
class Novosti {
  int novostId;
  String naslov;
  String? sadrzaj;
  bool? isLiked;
  int brojLajkova;
  DateTime datumObjave;
  int korisnikId;
  int? vrstaTreningaId;

  Novosti(
      {required this.novostId,
      required this.naslov,
      this.sadrzaj,
      this.isLiked,
      required this.brojLajkova,
      required this.datumObjave,
      required this.korisnikId,
      this.vrstaTreningaId});

  factory Novosti.fromJson(Map<String, dynamic> json) =>
      _$NovostiFromJson(json);

  Map<String, dynamic> toJson() => _$NovostiToJson(this);
}
