import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';

class CookbookState {
  final List<Recipe> recipes;
  final List<Category> categories;
  final Category? selectedCategory;

  CookbookState({required this.recipes, required this.categories, this.selectedCategory});

  CookbookState copyWith({
    List<Recipe>? recipes,
    List<Category>? categories,
    Category? selectedCategory,
  }) {
    return CookbookState(
      recipes: recipes ?? this.recipes,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}