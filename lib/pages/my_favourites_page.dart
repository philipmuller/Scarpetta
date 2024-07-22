import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';

class MyFavouritesPage extends ConsumerWidget {
  const MyFavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider).value;
    final user = ref.watch(userProvider).value;
    print("user: $user");
    final favourites = recipes?.where((recipe) {
      print("recipe: ${recipe.id}, ${recipe.name}");
      return user?['favourites'].contains(recipe.id);
    }).toList() ?? [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RecipesGrid(recipes: favourites),
      )
    );
  }
}