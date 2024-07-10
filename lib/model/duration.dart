import 'package:scarpetta/model/unit.dart';

class Duration {
  final int value;
  final Unit unit;

  Duration({required this.value, required this.unit});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
      value: json['value'],
      unit: Unit.fromJson(json['unit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'unit': unit.toJson(),
    };
  }
}