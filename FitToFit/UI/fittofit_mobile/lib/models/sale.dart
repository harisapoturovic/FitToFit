import 'package:fittofit_mobile/models/termini.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale.g.dart';

@JsonSerializable()
class Sale {
  int salaId;
  String naziv;
  String? velicina;
  String? slika;
  List<Termini>? terminis = [];

  Sale(
      {required this.salaId,
      required this.naziv,
      this.velicina,
      this.slika,
      this.terminis});

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  Map<String, dynamic> toJson() => _$SaleToJson(this);
}
