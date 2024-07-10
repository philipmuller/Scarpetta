import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final double topPadding = 60.0;
  final double xPadding = 30.0;

  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("The $categoryName category will be displayed here.")
    );
  }
}