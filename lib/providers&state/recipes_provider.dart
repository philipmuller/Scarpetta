import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipeProvider extends ChangeNotifier {
  final Map<String, Recipe> _recipesMap = {};
  Map<String, Recipe> get recipesMap => _recipesMap;

  String? _featuredRecipeId;
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

  final StreamController<void> _newRecipeController = StreamController<void>.broadcast();
  Stream<void> get newRecipeStream => _newRecipeController.stream;
  

  void updateRecipe(Recipe updatedRecipe) {
    _recipesMap[updatedRecipe.id] = updatedRecipe;
    CookbookService.updateRecipe(recipe: updatedRecipe);
    notifyListeners();
  }

  void deleteRecipe(String recipeId) {
    _recipesMap.remove(recipeId);
    CookbookService.deleteRecipe(recipeId);
    _newRecipeController.add(null);
    notifyListeners();
  }

  void addRecipe(Recipe newRecipe) async {
    final addedRecipe = await CookbookService.addRecipe(newRecipe);
    _recipesMap[addedRecipe.id] = addedRecipe;
    _newRecipeController.add(null);
    notifyListeners();
  }

  void fetchFeaturedRecipe() async {
    final featuredRecipe = await CookbookService.getFeaturedRecipe();
    _featuredRecipeId = featuredRecipe.id;
    _recipesMap[featuredRecipe.id] = featuredRecipe;
    notifyListeners();
  }

  

  Future<List<Recipe>> fetchRecipes(String? pageKey, int pageSize, Category? categoryFilter) async {
    // Simulate API call to fetch recipes
    final newRecipes = await CookbookService.getRecipes(pageKey: pageKey, pageSize: pageSize, category: categoryFilter);

    // Update the local map
    for (var recipe in newRecipes) {
      _recipesMap[recipe.id] = recipe;
    }
    notifyListeners();
    return newRecipes;
  }
}

final recipeProvider = RecipeProvider();