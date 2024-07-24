import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/favourites_button.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/recipe_page.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';

class RecipeCard extends StatelessWidget {
  final Recipe? recipe;
  final String? name;
  final String? description;
  final String? imageUrl;
  final int? favouriteCount;
  final String? recipeId;
  final bool isFavourite;
  final Function()? onTap;
  final Function()? onFavouriteTapped;

  const RecipeCard.withRecipe({super.key, required this.recipe, this.onTap, this.onFavouriteTapped, this.isFavourite = false}) : name = null, description = null, imageUrl = null, favouriteCount = null, recipeId = null;
  const RecipeCard.withDetails({super.key, required String name, required String description, required int favouriteCount, required String recipeId, required Function()? onTap, required this.imageUrl, this.onFavouriteTapped, this.isFavourite = false}) : recipe = null, name = name, description = description, favouriteCount = favouriteCount, recipeId = recipeId, onTap = onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double verticalPadding = 30.0;
    double horizontalPadding = 35.0;

    TextStyle titleStyle = Theme.of(context).textTheme.displaySmall!;
    TextStyle descriptionStyle = Theme.of(context).textTheme.bodyMedium!;

    final sessionProvider = Provider.of<SessionProvider>(context);

    if (width > Breakpoint.md) {
      verticalPadding = 20.0;
      horizontalPadding = 25.0;
      titleStyle = Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 25, fontWeight: FontWeight.w500);
      descriptionStyle = Theme.of(context).textTheme.bodySmall!;
    }

    return GestureDetector(
      onTap: () {
        onTap?.call();
        if (recipe != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe!)));
        }
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
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _recipeImage(context),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name ?? recipe!.name, style: titleStyle),
                      const SizedBox(height: 10.0),
                      Text(description ?? recipe!.description, style: descriptionStyle, maxLines: 3,),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              child: FavouritesButton(recipeId: recipeId ?? recipe!.id, count: favouriteCount ?? recipe!.favouriteCount, maxWidth: 80, isFilled: isFavourite, onPressed: sessionProvider.isLoggedIn ? onFavouriteTapped : null,),
            )
          ],
        ),
      ),
    );
  }

  Widget _recipeImage(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SCImage(imageUrl: imageUrl ?? recipe?.imageUrl, height: double.infinity,),
      ),
    );
  }
}