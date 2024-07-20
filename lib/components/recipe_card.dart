import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Function()? onTap;
  final String? categoryId;

  const RecipeCard({super.key, required this.recipe, this.onTap, this.categoryId});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        String categoryRoute = "all";
        if (categoryId != null) {
          categoryRoute = categoryId!;
        }
        onTap?.call();
        GoRouter.of(context).push('/recipes/${recipe.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Change shadow color with opacity
              spreadRadius: 2, // Spread radius of the shadow
              blurRadius: 4, // Blur radius of the shadow
              offset: const Offset(0, 4), // Position of the shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _recipeImage(context),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name, style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 10.0),
                  Text(recipe.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 3,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recipeImage(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SCImage(imageUrl: recipe.imageUrl, height: 320),
      ),
    );
  }
}