import 'package:flutter/material.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/components/recipe_card.dart';

class RecipesPage extends StatelessWidget {
  final double topPadding = 60.0;
  final double xPadding = 30.0;

  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CookbookService.recipes(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data as List<Recipe>;
        return GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 40,
            crossAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
          children: categories.map((recipe) {
            return RecipeCard(recipe: recipe);
          }).toList(),
        );
      }
    );
  }
}