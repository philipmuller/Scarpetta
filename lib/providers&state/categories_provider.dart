// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:scarpetta/model/category.dart';
// import 'package:scarpetta/model/recipe.dart';
// import 'package:scarpetta/services/cookbook_service.dart';

// class CategoriesProvider extends AsyncNotifier<List<Category>> {

//   List<Category> cachedCategories = [];

//   @override
//   Future<List<Category>> build() async {
//     print("CategoriesProvider build()");
//     final categories = await CookbookService.getCategories();
//     cachedCategories = categories;
//     return categories;
//   }

//   void fetchCategories() async {
//     print("CategoriesProvider fetchCategories()");
//     //final categories = await CookbookService.getCategories();
//     //cachedCategories = categories;
//     state = AsyncValue.data(cachedCategories);
//   }
  
// }

// final categoriesProvider = AsyncNotifierProvider<CategoriesProvider, List<Category>>(() {
//   return CategoriesProvider();
// });