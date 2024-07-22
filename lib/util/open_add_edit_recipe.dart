import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/add_edit_recipe_page.dart';
import 'package:scarpetta/pages/categories_page.dart';

void openAddEditRecipe({required BuildContext context, bool isMobile = false, Recipe? recipeToEdit, Function(Recipe)? onSubmit}) {
  if (isMobile) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: false,
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