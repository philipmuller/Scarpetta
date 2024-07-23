import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/categories_page.dart';

void openCategories({required BuildContext context, bool isMobile = true, Function(Category)? onCategoryTap, bool push = true}) {
  if (isMobile) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: false,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      context: context, 
      builder: (context) => _modalBuilder(context, onCategoryTap: onCategoryTap, push: push),
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
            constraints: const BoxConstraints(maxWidth: 800),
            child: _modalBuilder(context, onCategoryTap: onCategoryTap, push: push)
          ),
        );
      },
    );
  }
}

Widget _modalBuilder(BuildContext context, {Function(Category)? onCategoryTap, required bool push}) {
  return CategoriesPage(
    key: UniqueKey(),
    onCategoryTap: (category) {
      onCategoryTap?.call(category);
    },
    push: push,
  );
}