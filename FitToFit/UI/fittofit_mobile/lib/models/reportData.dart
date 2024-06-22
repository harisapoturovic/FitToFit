import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class ReportData {
  String naziv;
  String vrijednost;

  ReportData({
    required this.naziv,
    required this.vrijednost,
  });
}
