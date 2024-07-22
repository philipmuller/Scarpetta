import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipeNotifier extends StateNotifier<Recipe?> {
  RecipeNotifier() : super(null);

  void clearState() {
    state = null;
  }

  void fetchRecipe(String id) async {
    //clearState();
    final recipe = await CookbookService.getRecipe(id);
    state = recipe;
    print("state is now $state");
  }

  void updateRecipe({required Recipe updatedRecipe, String? id}) async {
    state = updatedRecipe;
    await CookbookService.updateRecipe(recipe: updatedRecipe, id: id);
  }
}

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, Recipe?>((ref) => RecipeNotifier());