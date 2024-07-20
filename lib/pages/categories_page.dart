import 'package:flutter/material.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class CategoriesPage extends StatelessWidget {
  final double topPadding = 60.0;
  final double xPadding = 30.0;
  final Function(Category)? onCategoryTap;
  final bool push;

  const CategoriesPage({super.key, this.onCategoryTap, this.push = false});

  @override
  Widget build(BuildContext context) {

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
            crossAxisCount: 3,
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