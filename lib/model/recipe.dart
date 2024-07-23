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
  final int favouriteCount;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final List<Category> categories;

  Recipe({
    String? id,
    this.authorId,
    required this.name,
    required this.description,
    this.imageUrl,
    this.favouriteCount = 0,
    this.ingredients = const [],
    this.steps = const [],
    this.categories = const [],
  }) :
    id = id ?? const Uuid().v4();

  factory Recipe.fromMap({required Map<String, dynamic> map, String? id}) {

    print("Starting conversion of Recipe from map named ${map['name']}");

    List<RecipeIngredient> ingredientsList = [];
    final ingredientsMapList = map['ingredients'];
    print("${map['ingredients']} of type ${map['ingredients'].runtimeType}");
    if (ingredientsMapList != null && ingredientsMapList.isNotEmpty) {
      ingredientsList = (ingredientsMapList as List).map((ingredient) {
        print("${ingredient} of type ${ingredient.runtimeType}");
        return RecipeIngredient.fromMap(map: ingredient);
      }).toList();
    }

    print("successfully converted ingredients");

    List<RecipeStep> stepsList = [];
    final stepsMapList = map['steps'];
    if (stepsMapList != null && stepsMapList.isNotEmpty) {
      stepsList = (stepsMapList as List).map((step) => RecipeStep.fromMap(map: step)).toList();
    }

    print("successfully converted steps");

    List<Category> categoriesList = [];
    final categoriesStringList = map['categories'];
    if (categoriesStringList != null && categoriesStringList.isNotEmpty) {
      categoriesList = (categoriesStringList as List).map((categoryName) => Category(name: categoryName)).toList();
    }

    print("successfully converted categories");

    print("${map['authorId']} of type ${map['authorId'].runtimeType}");
    print("${map['id']} of type ${map['id'].runtimeType}");
    print("${map['name']} of type ${map['name'].runtimeType}");
    print("${map['description']} of type ${map['description'].runtimeType}");
    print("${map['imageUrl']} of type ${map['imageUrl'].runtimeType}");
    print("${map['favouriteCount']} of type ${map['favouriteCount'].runtimeType}");
    print("${ingredientsList} of type ${ingredientsList.runtimeType}");
    print("${stepsList} of type ${stepsList.runtimeType}");

    return Recipe(
      id: id ?? map['id'],
      authorId: map['authorId'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      favouriteCount: map['favouriteCount'],
      ingredients: ingredientsList,
      steps: stepsList,
      categories: categoriesList,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'favouriteCount': favouriteCount,
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
    int? favouriteCount,
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
      favouriteCount: favouriteCount ?? this.favouriteCount,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      categories: categories ?? this.categories,
    );
  }
}