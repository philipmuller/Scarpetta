import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/pages/categories_page.dart';

void openCategories(BuildContext context, bool isMobile) {
  if (isMobile) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: false,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      context: context, 
      builder: _modalBuilder,
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
          child: Stack(
            children: [
              _modalBuilder(context),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: PhosphorIcon(PhosphorIconsRegular.x),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget _modalBuilder(BuildContext context) {
  return CategoriesPage(
    key: UniqueKey(),
    onCategoryTap: (category) {
      context.pop();
    },
    push: true,
  );
}