import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';

class FavouritesButton extends StatelessWidget {
  final String recipeId;
  final int count;
  final double maxWidth;

  FavouritesButton({required this.recipeId, required this.count, this.maxWidth = 100.0});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final recipesProvider = Provider.of<RecipeProvider>(context);

    final bool isFavourite = sessionProvider.userFavourites.contains(recipeId);

    return Container(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(240),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(28.0), bottomLeft: Radius.circular(30.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (isFavourite) {
                sessionProvider.removeFavourite(recipeId);
                recipesProvider.removeFavourite(recipeId);

              } else {
                sessionProvider.addFavourite(recipeId);
                recipesProvider.addFavourite(recipeId);
              }
            },
            icon: PhosphorIcon(isFavourite ? PhosphorIconsFill.star : PhosphorIconsRegular.star, color: Theme.of(context).colorScheme.onSecondaryContainer,),
          ),
          SizedBox(width: 1.0),
          Text(count.toString(), style: Theme.of(context).textTheme.bodyMedium,),
        ],
      ),
    );
  }
}