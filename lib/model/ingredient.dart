import 'package:scarpetta/model/unit.dart';

class Ingredient {
  String name;
  String? description;
  String? imageUrl;

  Ingredient({required this.name, this.description, this.imageUrl});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name': name,
    };

    if (description != null) {
      json['description'] = description!;
    }

    if (imageUrl != null) {
      json['imageUrl'] = imageUrl!;
    }

    return json;
  }
}

class RecipeIngredient extends Ingredient {
  double quantity;
  Unit unit;

  RecipeIngredient({required super.name, super.description, super.imageUrl, required this.quantity, required this.unit});

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
      unit: Unit.fromJson(json['unit']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();

    json.addAll({
      'quantity': quantity,
      'unit': unit.toJson(),
    });

    return json;
  }
}