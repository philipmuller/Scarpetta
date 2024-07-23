import 'package:flutter/material.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipeProvider extends ChangeNotifier {
  final Map<String, Recipe> _recipesMap = {};
  Map<String, Recipe> get recipesMap => _recipesMap;
  String? _featuredRecipeId = null;
  Recipe? get featuredRecipe {
    final recipe = _recipesMap.values.firstWhere(
      (recipe) => recipe.id == (_featuredRecipeId ?? ''), 
      orElse: () => Recipe(name: "NOT_FOUND", description: "")
    );
    if (recipe.name == "NOT_FOUND") {
      return null;
    }
    return recipe;
  }
  

  void updateRecipe(Recipe updatedRecipe) {
    _recipesMap[updatedRecipe.id] = updatedRecipe;
    notifyListeners();
  }

  void addRecipe(Recipe newRecipe) {
    _recipesMap[newRecipe.id] = newRecipe;
    notifyListeners();
  }

  void fetchFeaturedRecipe() async {
    final featuredRecipe = await CookbookService.getFeaturedRecipe();
    _featuredRecipeId = featuredRecipe.id;
    _recipesMap[featuredRecipe.id] = featuredRecipe;
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