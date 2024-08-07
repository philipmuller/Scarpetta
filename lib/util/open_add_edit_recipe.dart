import 'package:flutter/material.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/add_edit_recipe_page.dart';

void openAddEditRecipe({required BuildContext context, bool isMobile = false, Recipe? recipeToEdit, Function(Recipe)? onSubmit}) {
  if (isMobile) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      context: context, 
      builder: (context) => _modalBuilder(context, recipeToEdit: recipeToEdit, onSubmit: onSubmit),
    );
  } else {
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.all(130.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: _modalBuilder(context, recipeToEdit: recipeToEdit, onSubmit: onSubmit)
          ),
        );
      },
    );
  }
}

Widget _modalBuilder(BuildContext context, {Recipe? recipeToEdit, Function(Recipe)? onSubmit}) {
  return AddEditRecipePage(
    key: UniqueKey(),
    recipeToEdit: recipeToEdit,
    onSubmit: onSubmit,
  );
}