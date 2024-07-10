import 'package:flutter/material.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class CategoriesPage extends StatelessWidget {
  final double topPadding = 60.0;
  final double xPadding = 30.0;

  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CookbookService.categories(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data as List<String>;
        return GridView.count(
          padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: categories.map((category) {
            return CategoryIndicator(name: category);
          }).toList(),
        );
      }
    );
  }
}