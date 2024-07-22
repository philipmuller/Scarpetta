import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipesNotifier extends AsyncNotifier<List<Recipe>> {

  List<Recipe> cachedRecipes = [];
  
  @override
  Future<List<Recipe>> build() async {
    print("RecipesNotifier build()");
    final recipes = await CookbookService.getRecipes();
    cachedRecipes = recipes;
    return recipes;
  }

  filterByCategory(String? id) async {
    print("RecipesNotifier filterByCategory($id)");
    if (id == null) {
      state = AsyncValue.data(cachedRecipes);
      print("Served cached recipes");
      return;
    }
    final category = await CookbookService.getCategory(id);
    print("category: $category");
    state = AsyncValue.data(
      cachedRecipes // List<Recipe>
      .where(
        (recipe) => recipe.categories // List<Category>
        .where(
          (cachedCategory) => category.name == cachedCategory.name
        )
        .isNotEmpty
      ).toList()
    );
  }

  Recipe? recipeWithId(String id) {
    print("RecipesNotifier recipeWithId($id)");
    return state.value!.firstWhere((element) => element.id == id, orElse: () => Recipe(name: "Not found", description: "The recipe was not found"));
  }

  updateRecipe({required Recipe updatedRecipe, String? id}) async {
    print("RecipesNotifier updateRecipe($updatedRecipe, $id)");
    final finalId = id ?? updatedRecipe.id;
    print("finalId: $finalId");
    final updatedRecipes = cachedRecipes.map((element) => element.id == finalId ? updatedRecipe : element).toList();
    print(updatedRecipes);
    cachedRecipes = updatedRecipes;
    state = AsyncValue.data(updatedRecipes);
    await CookbookService.updateRecipe(recipe: updatedRecipe, id: finalId);
  }

  deleteRecipe({required String id}) async {
    print("RecipesNotifier deleteRecipe($id)");
    final updatedRecipes = cachedRecipes.where((element) => element.id != id).toList();
    cachedRecipes = updatedRecipes;
    state = AsyncValue.data(updatedRecipes);
    await CookbookService.deleteRecipe(id);
  }

  fetchRecipes() async {
    print("RecipesNotifier fetchRecipes()");
    final recipes = await CookbookService.getRecipes();
    cachedRecipes = recipes;
    state = AsyncValue.data(recipes);
  }

  addRecipe(Recipe recipe) async {
    print("RecipesNotifier addRecipe($recipe)");
    state = AsyncValue.data([recipe, ...state.value!]);
    await CookbookService.addRecipe(recipe);
    await fetchRecipes();
  }
  
}

final recipesProvider = AsyncNotifierProvider<RecipesNotifier, List<Recipe>>(() {
  return RecipesNotifier();
});