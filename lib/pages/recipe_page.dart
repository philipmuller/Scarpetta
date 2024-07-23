import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/favourites_button.dart';
import 'package:scarpetta/components/sc_app_bar.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/providers&state/navigation_state_provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_add_edit_recipe.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  const RecipePage({super.key, required this.recipe});

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
      //ref.read(recipesProvider.notifier).fetchRecipe(widget.recipe.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);

    print("PAGE RELOADED");
    double width = MediaQuery.of(context).size.width;
    bool isMobile = true;
    if (width > Breakpoint.md) {
      isMobile = false;
    }

    return Scaffold(
      appBar: SCAppBar(transparent: true,),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: 
      (widget.recipe.authorId == sessionProvider.user?.uid)
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                openAddEditRecipe(
                  context: context, 
                  isMobile: isMobile, 
                  recipeToEdit: recipeProvider.recipesMap[widget.recipe.id] ?? widget.recipe, 
                  onSubmit: (submittedRecipe) {
                    recipeProvider.updateRecipe(submittedRecipe);
                  }
                );
              }, 
              //label: const Text('Edit Recipe'),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: PhosphorIcon(PhosphorIconsRegular.pen, color: Theme.of(context).colorScheme.onSecondaryContainer,),
            ),
            const SizedBox(width: 20.0),
            FloatingActionButton(
              onPressed: () {
                showDialog(context: context, useRootNavigator: true, builder: (presentationContext) {
                  return AlertDialog(
                    title: const Text("Delete Recipe"),
                    content: const Text("Are you sure you want to delete this recipe?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(presentationContext).pop();
                        }, 
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(presentationContext);
                          recipeProvider.deleteRecipe(widget.recipe.id);
                          Navigator.pop(context);
                        }, 
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                });
              }, 
              backgroundColor: Theme.of(context).colorScheme.error,
              child: PhosphorIcon(PhosphorIconsRegular.trash, color: Theme.of(context).colorScheme.onError,),
            ),
          ],
        )
      : null,
      body: SingleChildScrollView(
        child: Consumer<RecipeProvider>(
          builder: (context, recipeProvider, child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(isMobile ? 0 : 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(isMobile ? Radius.zero : Radius.circular(30.0)),
                    child: SCImage(imageUrl: widget.recipe.imageUrl, height: isMobile ? 400.0 : 500.0)
                  ),
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
                          Flexible(child: Text(recipeProvider.recipesMap[widget.recipe.id]?.name ?? widget.recipe.name, style: Theme.of(context).textTheme.displayMedium)),
                          if (FirebaseAuth.instance.currentUser?.uid != null)
                            FavouritesButton(recipeId: widget.recipe.id, count: recipeProvider.recipesMap[widget.recipe.id]?.favouriteCount ?? widget.recipe.favouriteCount,)
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(recipeProvider.recipesMap[widget.recipe.id]?.description ?? widget.recipe.description, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 30.0),
                      Text("Ingredients", style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (recipeProvider.recipesMap[widget.recipe.id]?.ingredients ?? widget.recipe.ingredients)
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
                        children: (recipeProvider.recipesMap[widget.recipe.id]?.steps ?? widget.recipe.steps)
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
            );
          }
        )
      ),
    );
  }
}