import 'package:scarpetta/model/unit.dart';
import 'package:uuid/uuid.dart';

class Ingredient {
  String id;
  String name;
  String? description;
  String? imageUrl;

  Ingredient({String? id, required this.name, this.description, this.imageUrl}) : id = id ?? const Uuid().v4();

  factory Ingredient.fromMap({required Map<String, dynamic> map, String? id}) {
    return Ingredient(
      id: id ?? map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (description != null) {
      map['description'] = description!;
    }

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl!;
    }

    if (includeId) {
      map['id'] = id;
    }

    return map;
  }
}

class RecipeIngredient {
  Ingredient ingredient;
  double quantity;
  Unit unit;

  String name() => ingredient.name;
  String? description() => ingredient.description;
  String? imageUrl() => ingredient.imageUrl;

  RecipeIngredient({
    required String name, 
    String? description, 
    String? imageUrl, 
    required this.quantity, 
    required this.unit}) :
    ingredient = Ingredient(name: name, description: description, imageUrl: imageUrl);

  RecipeIngredient.fromIngredient({required this.ingredient, required this.quantity, required this.unit});

  factory RecipeIngredient.fromMap({required Map<String, dynamic> map}) {
    print("RecipeIngredient.fromMap: $map");
    final ingredientReference = map['reference'];
    String? ingredientReferenceId;
    if (ingredientReference != null) {
      ingredientReferenceId = ingredientReference.id;
      //print(ingredientReferenceId);
    }
    print("${map['quantity']} of type ${map['quantity'].runtimeType}");
    return RecipeIngredient.fromIngredient(
      ingredient: Ingredient.fromMap(map: map['ingredient'], id: ingredientReferenceId),
      quantity: map['quantity'].toDouble(),
      unit: Unit.fromMap(map: map['unit']),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> json = {
      'ingredient': ingredient.toMap(),
      'quantity': quantity,
      'unit': unit.toMap(),
    };

    return json;
  }
}