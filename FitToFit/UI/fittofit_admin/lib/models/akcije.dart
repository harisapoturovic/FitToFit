import 'package:fittofit_admin/models/akcijeTreninzi.dart';
import 'package:json_annotation/json_annotation.dart';

part 'akcije.g.dart';

@JsonSerializable()
class Akcije {
  int akcijaId;
  String naziv;
  DateTime datumPocetka;
  DateTime datumZavrsetka;
  int iznos;
  String? stateMachine;
  List<AkcijeTreninzi>? items = [];

  Akcije(
      {required this.akcijaId,
      required this.naziv,
      required this.datumPocetka,
      required this.datumZavrsetka,
      required this.iznos,
      this.stateMachine,
      this.items});

  factory Akcije.fromJson(Map<String, dynamic> json) => _$AkcijeFromJson(json);

  Map<String, dynamic> toJson() => _$AkcijeToJson(this);
}
