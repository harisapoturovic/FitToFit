import 'package:json_annotation/json_annotation.dart';

part 'odabraniTermini.g.dart';

@JsonSerializable()
class OdabraniTermini {
  int count;
  String opis;

  OdabraniTermini(
      {required this.count,
      required this.opis});

  factory OdabraniTermini.fromJson(Map<String, dynamic> json) => _$OdabraniTerminiFromJson(json);

  Map<String, dynamic> toJson() => _$OdabraniTerminiToJson(this);
}
