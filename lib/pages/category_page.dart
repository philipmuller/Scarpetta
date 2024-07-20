import 'package:flutter/material.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/recipes_page.dart';

class CategoryPage extends StatelessWidget {
  final double topPadding = 60.0;
  final double xPadding = 30.0;

  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return RecipesPage(category: Category(id: categoryId, name: ""));
  }
}