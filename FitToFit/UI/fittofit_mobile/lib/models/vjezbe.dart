import 'package:fittofit_mobile/models/vjezbeTreninzi.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vjezbe.g.dart';

@JsonSerializable()
class Vjezbe {
  int vjezbaId;
  String naziv;
  String? opis;
  String? slika;
  List<VjezbeTreninzi>? treninziVjezbes = [];

  Vjezbe(
      {required this.vjezbaId,
      required this.naziv,
      this.opis,
      this.slika,
      this.treninziVjezbes});

  factory Vjezbe.fromJson(Map<String, dynamic> json) => _$VjezbeFromJson(json);

  Map<String, dynamic> toJson() => _$VjezbeToJson(this);
}
