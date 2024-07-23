import 'package:flutter/material.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class CategoryProvider extends ChangeNotifier {
  final Map<String, Category> _categoryMap = {};
  Map<String, Category> get recipesMap => _categoryMap;

  Future<List<Category>> fetchCategories(String? pageKey, int pageSize) async {
    // Simulate API call to fetch recipes
    final newCategories = await CookbookService.getCategories(pageKey: pageKey, pageSize: pageSize);

    // Update the local map
    for (var category in newCategories) {
      _categoryMap[category.id] = category;
    }
    notifyListeners();
    return newCategories;
  }
}

final categoryProvider = CategoryProvider();