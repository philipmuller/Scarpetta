import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_add_edit_recipe.dart';

class RecipePage extends StatefulWidget {
  final String? recipeId;

  const RecipePage({super.key, this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final double topPadding = 20.0;
  final double xPadding = 30.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      //ref.read(recipesProvider.notifier).fetchRecipe(widget.recipeId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("PAGE RELOADED");
    double width = MediaQuery.of(context).size.width;
    bool isMobile = true;
    if (width > Breakpoint.md) {
      isMobile = false;
    }

    //final recipes = ref.watch(recipesProvider);
    //final recipe = recipes.value?.firstWhere((element) => element.id == widget.recipeId);
    //final user = ref.watch(userProvider);
    final isUserFavourite = true;//user.value?['favourites'].contains(widget.recipeId);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(isMobile ? 0 : 10.0),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.all(isMobile ? Radius.zero : Radius.circular(30.0)),
                //   child: SCImage(imageUrl: recipe?.imageUrl, height: isMobile ? 400.0 : 500.0)
                // ),
              ),
              Padding(
                padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Flexible(child: Text(recipe?.name ?? '', style: Theme.of(context).textTheme.displayMedium)),
                        if (FirebaseAuth.instance.currentUser?.uid != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 7.0),
                            child: IconButton(
                              onPressed: () {
                                if (!isUserFavourite) {
                                  if (widget.recipeId != null) {
                                    print("FAVORITE RECIPE: ${widget.recipeId}");
                                    //ref.watch(userProvider.notifier).favouriteRecipe(widget.recipeId!);
                                  }
                                } else {
                                  if (widget.recipeId != null) {
                                    print("UNFAVORITE RECIPE: ${widget.recipeId}");
                                    //ref.watch(userProvider.notifier).unFavouriteRecipe(widget.recipeId!);
                                  }
                                }
                              },
                              icon: PhosphorIcon(isUserFavourite ? PhosphorIconsFill.star : PhosphorIconsRegular.star, color: Theme.of(context).colorScheme.onSecondaryContainer,),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    //Text(recipe?.description ?? ''),
                    const SizedBox(height: 30.0),
                    Text("Ingredients", style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: []//(recipe?.ingredients ?? [])
                        .map((ingredient) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          child: Text("${ingredient.quantity}${ingredient.unit.abbreviation} ${ingredient.name()}"),
                        ))
                        .toList(),
                    ),
                    const SizedBox(height: 30.0),
                    Text("Steps", style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10.0),
                    Column(
                      children: []//(recipe?.steps ?? [])
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Text(
                                  "${entry.key + 1}",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                  ),
                                ), 
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                              ),
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
        ),
        if (FirebaseAuth.instance.currentUser?.uid == "")//recipe?.authorId)
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton.small(
                  onPressed: () {
                    openAddEditRecipe(
                      context: context, 
                      isMobile: isMobile, 
                      //recipeToEdit: recipe, 
                      onSubmit: (submittedRecipe) {
                        //final provider = ref.read(recipesProvider.notifier);
                        //provider.updateRecipe(updatedRecipe: submittedRecipe, id: widget.recipeId);
                      }
                    );
                  }, 
                  //label: const Text('Edit Recipe'),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  child: PhosphorIcon(PhosphorIconsRegular.pen, color: Theme.of(context).colorScheme.onSecondaryContainer,),
                ),
                const SizedBox(width: 20.0),
                const SizedBox(width: 20.0),
                FloatingActionButton.small(
                  onPressed: () {
                    if (widget.recipeId != null) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Recipe"),
                          content: const Text("Are you sure you want to delete this recipe?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                //ref.read(recipesProvider.notifier).deleteRecipe(id: widget.recipeId!);
                              }, 
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.error,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      });
                    }
                  }, 
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: PhosphorIcon(PhosphorIconsRegular.trash, color: Theme.of(context).colorScheme.onError,),
                ),
              ],
            ),
          ),
      ],
    );
  }
}