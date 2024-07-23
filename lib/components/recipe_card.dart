import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/recipe_page.dart';
import 'package:scarpetta/util/breakpoint.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Function()? onTap;

  const RecipeCard({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double verticalPadding = 30.0;
    double horizontalPadding = 35.0;

    TextStyle titleStyle = Theme.of(context).textTheme.displaySmall!;
    TextStyle descriptionStyle = Theme.of(context).textTheme.bodyMedium!;

    if (width > Breakpoint.md) {
      verticalPadding = 20.0;
      horizontalPadding = 25.0;
      titleStyle = Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 25, fontWeight: FontWeight.w500);
      descriptionStyle = Theme.of(context).textTheme.bodySmall!;
    }

    return GestureDetector(
      onTap: () {
        onTap?.call();
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)));
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name, style: titleStyle),
                  const SizedBox(height: 10.0),
                  Text(recipe.description, style: descriptionStyle, maxLines: 3,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recipeImage(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SCImage(imageUrl: recipe.imageUrl, height: double.infinity,),
      ),
    );
  }
}