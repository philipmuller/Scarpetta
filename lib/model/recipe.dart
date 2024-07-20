import 'package:scarpetta/model/ingredient.dart';
import 'package:scarpetta/model/recipe_step.dart';
import 'package:uuid/uuid.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  Recipe({
    String? id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.ingredients = const [],
    this.steps = const [],
  }) :
    id = id ?? const Uuid().v4();

  factory Recipe.fromMap({required Map<String, dynamic> map, String? id}) {

    List<RecipeIngredient> ingredientsList = [];
    final ingredientsMapList = map['ingredients'];
    if (ingredientsMapList != null && ingredientsMapList.isNotEmpty) {
      ingredientsList = (ingredientsMapList as List).map((ingredient) => RecipeIngredient.fromMap(map: ingredient)).toList();
    }

    List<RecipeStep> stepsList = [];
    final stepsMapList = map['steps'];
    if (stepsMapList != null && stepsMapList.isNotEmpty) {
      stepsList = (stepsMapList as List).map((step) => RecipeStep.fromMap(map: step)).toList();
    }

    return Recipe(
      id: id ?? map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      ingredients: ingredientsList,
      steps: stepsList,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
      'steps': steps.map((step) => step.toMap()).toList(),
    };

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl!;
    }

    if (includeId) {
      map['id'] = id;
    }

    return map;
  }
}