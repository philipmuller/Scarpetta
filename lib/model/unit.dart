import 'package:phosphor_flutter/phosphor_flutter.dart';

final Map<String, PhosphorFlatIconData> unitIcons = {
  'kg': PhosphorIconsRegular.scales,
  'g': PhosphorIconsRegular.scales,
  'l': PhosphorIconsRegular.drop,
  'ml': PhosphorIconsRegular.dropHalf,
  'tbsp': PhosphorIconsRegular.scales,
  'tsp': PhosphorIconsRegular.scales,
  'cup': PhosphorIconsRegular.pintGlass,
  'pint': PhosphorIconsRegular.pintGlass,
  'pinch': PhosphorIconsRegular.scales,
  'm': PhosphorIconsRegular.ruler,
  'cm': PhosphorIconsRegular.ruler,
  'mm': PhosphorIconsRegular.ruler,
  'inch': PhosphorIconsRegular.ruler,
  'ft': PhosphorIconsRegular.ruler,
  'oz': PhosphorIconsRegular.scales,
  'lb': PhosphorIconsRegular.scales,
  's': PhosphorIconsRegular.timer,
  'min': PhosphorIconsRegular.timer,
  'h': PhosphorIconsRegular.timer,
};

class Unit {
  String? name;
  String abbreviation;
  PhosphorIcon? symbol;

  Unit({this.name, required this.abbreviation, this.symbol});

  factory Unit.fromMap({required Map<String, dynamic> map}) {
    String abbreviation = map['abbreviation'];
    return Unit(
      name: map['name'],
      abbreviation: abbreviation,
      symbol: PhosphorIcon(unitIcons[abbreviation] ?? PhosphorIconsRegular.scales)
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'abbreviation': abbreviation,
  };

  static Unit unit = Unit(name: 'Unit', abbreviation: '');
  static Unit kilogram = Unit(name: 'Kilogram', abbreviation: 'kg', symbol: PhosphorIcon(unitIcons['kg']!));
  static Unit gram = Unit(name: 'Gram', abbreviation: 'g', symbol: PhosphorIcon(unitIcons['g']!));
  static Unit liter = Unit(name: 'Liter', abbreviation: 'l', symbol: PhosphorIcon(unitIcons['l']!));
  static Unit milliliter = Unit(name: 'Milliliter', abbreviation: 'ml', symbol: PhosphorIcon(unitIcons['ml']!));
  static Unit tablespoon = Unit(name: 'Tablespoon', abbreviation: 'tbsp', symbol: PhosphorIcon(unitIcons['tbsp']!));
  static Unit teaspoon = Unit(name: 'Teaspoon', abbreviation: 'tsp', symbol: PhosphorIcon(unitIcons['tsp']!));
  static Unit cup = Unit(name: 'Cup', abbreviation: 'cup', symbol: PhosphorIcon(unitIcons['cup']!));
  static Unit pint = Unit(name: 'Pint', abbreviation: 'pint', symbol: PhosphorIcon(unitIcons['pint']!));
  static Unit pinch = Unit(name: 'Pinch', abbreviation: 'pinch', symbol: PhosphorIcon(unitIcons['pinch']!));
  static Unit meter = Unit(name: 'Meter', abbreviation: 'm', symbol: PhosphorIcon(unitIcons['m']!));
  static Unit centimeter = Unit(name: 'Centimeter', abbreviation: 'cm', symbol: PhosphorIcon(unitIcons['cm']!));
  static Unit millimeter = Unit(name: 'Millimeter', abbreviation: 'mm', symbol: PhosphorIcon(unitIcons['mm']!));
  static Unit inch = Unit(name: 'Inch', abbreviation: 'inch', symbol: PhosphorIcon(unitIcons['inch']!));
  static Unit foot = Unit(name: 'Foot', abbreviation: 'ft', symbol: PhosphorIcon(unitIcons['ft']!));
  static Unit ounce = Unit(name: 'Ounce', abbreviation: 'oz', symbol: PhosphorIcon(unitIcons['oz']!));
  static Unit pound = Unit(name: 'Pound', abbreviation: 'lb', symbol: PhosphorIcon(unitIcons['lb']!));
  static Unit second = Unit(name: 'Second', abbreviation: 's', symbol: PhosphorIcon(unitIcons['s']!));
  static Unit minute = Unit(name: 'Minute', abbreviation: 'm', symbol: PhosphorIcon(unitIcons['m']!));
  static Unit hour = Unit(name: 'Hour', abbreviation: 'h', symbol: PhosphorIcon(unitIcons['h']!));
}