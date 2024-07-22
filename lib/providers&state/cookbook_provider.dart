import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/providers&state/cookbook_state.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class CookbookNotifier extends AsyncNotifier<CookbookState> {
  @override
  Future<CookbookState> build() async {
    final recipes = await CookbookService.getRecipes();
    final categories = await CookbookService.getCategories();
    return CookbookState(recipes: recipes, categories: categories);
  }

  void filterByCategory(String? id) async {
    state = AsyncValue.data(state.value!.copyWith(recipes: await CookbookService.getRecipes(categoryId: id)));
  }

  void fetchRecipes() async {
    final recipes = await CookbookService.getRecipes();
    state = AsyncValue.data(state.value!.copyWith(recipes: recipes));
  }

  void fetchCategories() async {
    final categories = await CookbookService.getCategories();
    state = AsyncValue.data(state.value!.copyWith(categories: categories));
  }

  void addRecipe(Recipe recipe) async {
    state = AsyncValue.data(state.value!.copyWith(recipes: [recipe, ...state.value!.recipes]));
    await CookbookService.addRecipe(recipe);
  }

  void updateRecipe({required Recipe recipe, String? id}) async {
    final index = state.value!.recipes.indexWhere((element) => element.id == (id ?? recipe.id));
    List<Recipe> updatedRecipes = state.value!.recipes;
    updatedRecipes[index] = recipe;
    state = AsyncValue.data(state.value!.copyWith(recipes: updatedRecipes));
    await CookbookService.updateRecipe(recipe: recipe, id: id);
  }
  
}

final cookbookProvider =
    AsyncNotifierProvider<CookbookNotifier, CookbookState>(() {
      return CookbookNotifier();
    });