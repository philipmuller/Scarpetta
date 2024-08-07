import 'package:scarpetta/model/unit.dart';

class Duration {
  final int value;
  final Unit unit;

  Duration({required this.value, required this.unit});

  factory Duration.fromMap(Map<String, dynamic> map) {
    print("Starting conversion of Duration from map named ${map['value']}");

    print("${map['value']} of type ${map['value'].runtimeType}");
    print("${map['unit']} of type ${map['unit'].runtimeType}");
    return Duration(
      value: map['value'],
      unit: Unit.fromMap(map: map['unit']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'unit': unit.toMap(),
    };
  }
}