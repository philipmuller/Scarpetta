import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';

class MyRecipesPage extends ConsumerWidget {
  const MyRecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider).value;
    final user = ref.watch(userProvider).value;
    final myRecipes = recipes?.where((recipe) => user?['creations'].contains(recipe.id)).toList() ?? [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: myRecipes.isEmpty ? const Center(child: Text("You haven't created any recipes yet")) : RecipesGrid(recipes: myRecipes),
      ),
    );
  }
}