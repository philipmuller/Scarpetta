import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipesNotifier extends StateNotifier<List<Recipe>> {
  RecipesNotifier() : super([]) {
    fetchRecipes(null);
  }

  void fetchRecipes(String? categoryId) async {
    final recipes = await CookbookService.getRecipes(categoryId: categoryId);
    state = recipes;
  }

  void addRecipe(Recipe recipe) async {
    state = [recipe, ...state];
    await CookbookService.addRecipe(recipe);
  }

  void updateRecipe({required Recipe recipe, String? id}) async {
    final index = state.indexWhere((element) => element.id == (id ?? recipe.id));
    state[index] = recipe;
    await CookbookService.updateRecipe(recipe: recipe, id: id);
  }
}

final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final recipes = await CookbookService.getRecipes();
  return recipes;
});