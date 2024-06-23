import 'package:fittofit_mobile/models/akcijeTreninzi.dart';
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
  List<AkcijeTreninzi>? akcijeTreninzis = [];

  Akcije(
      {required this.akcijaId,
      required this.naziv,
      required this.datumPocetka,
      required this.datumZavrsetka,
      required this.iznos,
      this.stateMachine,
      this.akcijeTreninzis});

  factory Akcije.fromJson(Map<String, dynamic> json) => _$AkcijeFromJson(json);

  Map<String, dynamic> toJson() => _$AkcijeToJson(this);
}
