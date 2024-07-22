import 'package:flutter/material.dart';
import 'package:scarpetta/components/recipe_card.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/util/breakpoint.dart';

class RecipesGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final EdgeInsets? padding;
  final Function()? onRecipeTap;

  const RecipesGrid({super.key, required this.recipes, this.padding, this.onRecipeTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int numberOfColumns = 1;
    double mainAxisSpacing = 40;
    double crossAxisSpacing = 10;
    if (width > Breakpoint.md) {
      numberOfColumns = 2;
      mainAxisSpacing = 30;
      crossAxisSpacing = 30;
    }
    // if (width > Breakpoint.lg) {
    //   numberOfColumns = 3;
    //   mainAxisSpacing = 40;
    //   crossAxisSpacing = 40;
    // }

    return GridView(
      clipBehavior: Clip.none,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numberOfColumns,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 0.9,
      ),
      padding: padding,
      children: recipes.map((recipe) {
        return RecipeCard(recipe: recipe, onTap: onRecipeTap);
      }).toList(),
    );
  }
}