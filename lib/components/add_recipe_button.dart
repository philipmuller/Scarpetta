import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_add_edit_recipe.dart';

class AddRecipeButton extends StatelessWidget {
  final bool extended;
  const AddRecipeButton({Key? key, this.extended = false}) : super(key: key);

  @override
  Widget build(BuildContext context){//, WidgetRef ref) {
    if (extended) {
      return FloatingActionButton.extended(
        onPressed: () {
          onButtonPressed(context);
        }, 
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        label: const Text('Add Recipe'),
        icon: const PhosphorIcon(PhosphorIconsRegular.plus),
      );
    }

    return FloatingActionButton(
      onPressed: () {
        onButtonPressed(context);
      }, 
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: const PhosphorIcon(PhosphorIconsRegular.plus),
    );
  }

  void onButtonPressed(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < Breakpoint.md;
    openAddEditRecipe(
      context: context, 
      isMobile: isMobile, 
      onSubmit: (recipe) {
        print("Adding recipe: $recipe");
        recipeProvider.addRecipe(recipe);
    });
  }
}