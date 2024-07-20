import 'package:flutter/material.dart';
import 'package:scarpetta/components/recipe_card.dart';
import 'package:scarpetta/model/recipe.dart';

class RecipesGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final EdgeInsets? padding;
  final Function()? onRecipeTap;
  final String? categoryId;

  const RecipesGrid({super.key, required this.recipes, this.padding, this.onRecipeTap, this.categoryId});

  @override
  Widget build(BuildContext context) {
    return GridView(
      clipBehavior: Clip.none,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 40,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      padding: padding,
      children: recipes.map((recipe) {
        return RecipeCard(recipe: recipe, onTap: onRecipeTap, categoryId: categoryId);
      }).toList(),
    );
  }
}