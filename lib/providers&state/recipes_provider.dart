import 'package:flutter/material.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipeProvider extends ChangeNotifier {
  final Map<String, Recipe> _recipesMap = {};
  Map<String, Recipe> get recipesMap => _recipesMap;

  void updateRecipe(Recipe updatedRecipe) {
    _recipesMap[updatedRecipe.id] = updatedRecipe;
    notifyListeners();
  }

  void addRecipe(Recipe newRecipe) {
    _recipesMap[newRecipe.id] = newRecipe;
    notifyListeners();
  }

  Future<List<Recipe>> fetchRecipes(String? pageKey, int pageSize) async {
    // Simulate API call to fetch recipes
    final newRecipes = await CookbookService.getRecipes(pageKey: pageKey, pageSize: pageSize);

    // Update the local map
    for (var recipe in newRecipes) {
      _recipesMap[recipe.id] = recipe;
    }
    notifyListeners();
    return newRecipes;
  }
}

final recipeProvider = RecipeProvider();