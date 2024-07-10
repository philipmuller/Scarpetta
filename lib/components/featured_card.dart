import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/components/plate.dart';
import 'package:scarpetta/model/recipe.dart';

class FeaturedCard extends StatelessWidget {
  final Future<Recipe> recipe;
  const FeaturedCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recipe,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final recipe = snapshot.data as Recipe;
          return GestureDetector(
            onTap: () {
              print("Featured card sent recipeId: ${recipe.id}");
              GoRouter.of(context).push("/recipes/${recipe.id}");
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(35.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Change shadow color with opacity
                    spreadRadius: 10, // Spread radius of the shadow
                    blurRadius: 10, // Blur radius of the shadow
                    offset: Offset(0, 0), // Position of the shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: const Plate()
                  ),
                  const SizedBox(height: 20.0),
                  Text(recipe.name, style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      }
    );
  }
}