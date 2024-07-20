import 'package:flutter/material.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class RecipePage extends StatelessWidget {
  final String recipeId;
  final double topPadding = 20.0;
  final double xPadding = 30.0;

  const RecipePage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    print("Recipe Page received recipeId: $recipeId");
    return FutureBuilder<Recipe?>(
      future: CookbookService.getRecipe(recipeId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Center(child: Text("Recipe not found"));
          }

          final recipe = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                SCImage(imageUrl: recipe.imageUrl, height: 400.0),
                Padding(
                  padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name, style: Theme.of(context).textTheme.displayMedium),
                      const SizedBox(height: 20.0),
                      Text(recipe.description),
                      const SizedBox(height: 30.0),
                      if (recipe.ingredients.isNotEmpty)
                        Text("Ingredients", style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.ingredients
                          .map((ingredient) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            child: Text("${ingredient.quantity}${ingredient.unit.abbreviation} ${ingredient.name()}"),
                          ))
                          .toList(),
                      ),
                      const SizedBox(height: 30.0),
                      if (recipe.steps.isNotEmpty)
                        Text("Steps", style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10.0),
                      Column(
                        children: recipe.steps
                          .asMap()
                          .entries
                          .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(child: Text("${entry.key + 1}")),
                                const SizedBox(width: 15.0),
                                Flexible(
                                  child: Text(
                                    entry.value.description,
                                    softWrap: true,
                                  ),
                                ),
                              ]
                            ),
                          ))
                          .toList(),
                      ),
                  ],),
                ),
              ],
            )
          );
        }

        return const Center(child: CircularProgressIndicator());
      }
    );
  }
}