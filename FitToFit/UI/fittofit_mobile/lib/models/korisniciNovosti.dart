import 'package:json_annotation/json_annotation.dart';

part 'korisniciNovosti.g.dart';

@JsonSerializable()
class KorisniciNovosti {
  int korisniciNovostiId;
  int korisnikId;
  int novostId;
  bool isLiked;
  bool isRead;

  KorisniciNovosti(
      {required this.korisniciNovostiId,
      required this.korisnikId,
      required this.novostId,
      required this.isLiked,
      required this.isRead});

  factory KorisniciNovosti.fromJson(Map<String, dynamic> json) =>
      _$KorisniciNovostiFromJson(json);

  Map<String, dynamic> toJson() => _$KorisniciNovostiToJson(this);
}
