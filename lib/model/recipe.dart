import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/ingredient.dart';
import 'package:scarpetta/model/recipe_step.dart';
import 'package:uuid/uuid.dart';

class Recipe {
  final String id;
  final String? authorId;
  final String name;
  final String description;
  final String? imageUrl;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final List<Category> categories;

  Recipe({
    String? id,
    this.authorId,
    required this.name,
    required this.description,
    this.imageUrl,
    this.ingredients = const [],
    this.steps = const [],
    this.categories = const [],
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

    List<Category> categoriesList = [];
    final categoriesStringList = map['categories'];
    if (categoriesStringList != null && categoriesStringList.isNotEmpty) {
      categoriesList = (categoriesStringList as List).map((categoryName) => Category(name: categoryName)).toList();
    }

    return Recipe(
      id: id ?? map['id'],
      authorId: map['authorId'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      ingredients: ingredientsList,
      steps: stepsList,
      categories: categoriesList,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
      'steps': steps.map((step) => step.toMap()).toList(),
      'categories': categories.map((category) => category.name).toList(),
    };

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl!;
    }

    if (authorId != null) {
      map['authorId'] = authorId!;
    }

    if (includeId) {
      map['id'] = id;
    }

    return map;
  }

  Recipe copyWith({
    String? id,
    String? authorId,
    String? name,
    String? description,
    String? imageUrl,
    List<RecipeIngredient>? ingredients,
    List<RecipeStep>? steps,
    List<Category>? categories,
  }) {
    return Recipe(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      categories: categories ?? this.categories,
    );
  }
}