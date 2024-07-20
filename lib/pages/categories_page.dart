import 'package:flutter/material.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';

class CategoriesPage extends StatelessWidget {
  final Function(Category)? onCategoryTap;
  final bool push;

  const CategoriesPage({super.key, this.onCategoryTap, this.push = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topPadding = 60.0;
    double xPadding = 30.0;
    int gridColumns = 3;
    if (width > Breakpoint.lg) {
      gridColumns = 2;
      xPadding = 10.0;
    }

    return FutureBuilder(
      future: CookbookService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: GridView.count(
            padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
            crossAxisCount: gridColumns,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            children: snapshot.data!.map((category) {
              return CategoryIndicator(
                category: category,
                onTap: onCategoryTap,
                push: push,
              );
            }).toList(),
          ),
        );
      }
    );
  }
}