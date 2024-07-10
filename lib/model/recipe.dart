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
}