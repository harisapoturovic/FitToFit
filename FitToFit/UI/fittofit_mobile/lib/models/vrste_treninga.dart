import 'package:json_annotation/json_annotation.dart';

part 'vrste_treninga.g.dart';

@JsonSerializable()
class VrsteTreninga {
  int? vrstaTreningaId;
  String? naziv;
  String? opis;

  VrsteTreninga(this.vrstaTreningaId, this.naziv, this.opis);

  factory VrsteTreninga.fromJson(Map<String, dynamic> json) =>
      _$VrsteTreningaFromJson(json);

  Map<String, dynamic> toJson() => _$VrsteTreningaToJson(this);
}
