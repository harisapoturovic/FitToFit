import 'package:json_annotation/json_annotation.dart';

part 'profit.g.dart';

@JsonSerializable()
class Profit {
  double profitGod1;
  double profitGod2;
  double profitGod3;

  Profit(
      {required this.profitGod1,
      required this.profitGod2,
      required this.profitGod3});

  factory Profit.fromJson(Map<String, dynamic> json) => _$ProfitFromJson(json);

  Map<String, dynamic> toJson() => _$ProfitToJson(this);
}
