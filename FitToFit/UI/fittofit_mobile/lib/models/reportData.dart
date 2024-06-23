// ignore_for_file: file_names

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
