import 'package:flutter/material.dart';
import 'package:scarpetta/components/recipes_grid.dart';

class MyRecipesPage extends StatelessWidget {
  const MyRecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){//, WidgetRef ref) {
    //final recipes = ref.watch(recipesProvider).value;
    //final user = ref.watch(userProvider).value;
    //final myRecipes = recipes?.where((recipe) => user?['creations'].contains(recipe.id)).toList() ?? [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: RecipesGrid(filterCreatedByUser: true),
      ),
    );
  }
}