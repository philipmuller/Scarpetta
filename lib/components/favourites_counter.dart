import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';

class FavouritesCounter extends StatelessWidget {
  final Recipe? recipe;

  const FavouritesCounter({super.key, this.recipe});

  @override
  Widget build(BuildContext context){//, WidgetRef ref) {
    //final user = ref.watch(userProvider);
    final isUserFavourite = true;//user.value?['favourites'].contains(recipe?.id) ?? false;

    int favouriteCount = recipe?.favouriteCount ?? 0;
    
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 7.0),
        child: IconButton(
          onPressed: () {
            //final recipesPrv = ref.read(recipesProvider.notifier);
            //final userPrv = ref.read(userProvider.notifier);
            if (!isUserFavourite) {
              if (recipe?.id != null) {
                print("FAVORITE RECIPE: ${recipe?.id}");
                //recipesPrv.favouriteRecipe(recipe!.id);
                //userPrv.favouriteRecipe(recipe!.id);
              }
            } else {
              if (recipe?.id != null) {
                print("UNFAVORITE RECIPE: ${recipe?.id}");
                //recipesPrv.unFavouriteRecipe(recipe!.id);
                //userPrv.unFavouriteRecipe(recipe!.id);
              }
            }
          },
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PhosphorIcon(isUserFavourite ? PhosphorIconsFill.star : PhosphorIconsRegular.star, color: Theme.of(context).colorScheme.onSecondaryContainer,),
              const SizedBox(width: 5.0),
              Text("$favouriteCount", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
    

}
