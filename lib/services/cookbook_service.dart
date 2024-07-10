import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/model/ingredient.dart';
import 'package:scarpetta/model/unit.dart';
import 'package:scarpetta/model/recipe_step.dart';
import 'package:scarpetta/model/duration.dart';

class CookbookService {
  static Future<Recipe?> getRecipe(String id) async {
    try {
      return mockRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<Recipe> featuredRecipe() async {
    return mockRecipes[1];
  }

  static Future<List<Recipe>> recipes() async {
    return mockRecipes;
  }

  static Future<List<String>> categories() async {
    return mockCategories;
  }
}

final mockRecipes = [
  Recipe(
    name: "Spaghetti Carbonara",
    description: "Spaghetti Carbonara is a classic Italian pasta dish that's creamy, rich, and easy to make! The authentic recipe calls for eggs, pancetta, cheese, and pepper. So simple, so easy!",
    ingredients: [
      RecipeIngredient(name: "Spaghetti", quantity: 200, unit: Unit.gram),
      RecipeIngredient(name: "Eggs", quantity: 2, unit: Unit.unit),
      RecipeIngredient(name: "Pancetta", quantity: 100, unit: Unit.gram),
      RecipeIngredient(name: "Pecorino Romano", quantity: 50, unit: Unit.gram),
      RecipeIngredient(name: "Black Pepper", quantity: 1, unit: Unit.teaspoon),
    ],
    steps: [
      RecipeStep(description: "Cook the spaghetti in a large pot of salted boiling water until al dente.", duration: Duration(value: 10, unit: Unit.minute)),
      RecipeStep(description: "In a large bowl, whisk together the eggs, cheese, and pepper.", duration: Duration(value: 5, unit: Unit.minute)),
      RecipeStep(description: "In a large skillet, cook the pancetta until crispy.", duration: Duration(value: 5, unit: Unit.minute)),
      RecipeStep(description: "Drain the spaghetti and add it to the skillet with the pancetta.", duration: Duration(value: 1, unit: Unit.minute)),
      RecipeStep(description: "Remove the skillet from the heat and add the egg mixture.", duration: Duration(value: 1, unit: Unit.minute)),
      RecipeStep(description: "Toss the spaghetti until the sauce is creamy and the eggs are cooked.", duration: Duration(value: 1, unit: Unit.minute)),
    ],
  ),
  Recipe(
    name: "Pasta Aglio e Olio",
    description: "Pasta Aglio e Olio is a traditional Italian pasta dish that's simple, delicious, and easy to make. The authentic recipe calls for garlic, olive oil, red pepper flakes, and parsley. So simple, so easy!",
  ),
  Recipe(
    name: "Pasta alla Puttanesca",
    description: "Pasta alla Puttanesca is a traditional Italian pasta dish that's savory, tangy, and easy to make. The authentic recipe calls for tomatoes, olives, capers, anchovies, and garlic. So simple, so easy!",
  ),
  Recipe(
    name: "Pasta alla Norma",
    description: "Pasta alla Norma is a traditional Italian pasta dish that's simple, delicious, and easy to make. The authentic recipe calls for eggplant, tomatoes, basil, and ricotta salata. So simple, so easy!",
  ),
  Recipe(
    name: "Pasta al Pomodoro",
    description: "Pasta al Pomodoro is a traditional Italian pasta dish that's simple, delicious, and easy to make. The authentic recipe calls for tomatoes, garlic, basil, and olive oil. So simple, so easy!",
  ),
  Recipe(
    name: "Pasta al Limone",
    description: "Pasta al Limone is a traditional Italian pasta dish that's simple, delicious, and easy to make. The authentic recipe calls for lemon, cream, and Parmesan cheese. So simple, so easy!",
  ),
  Recipe(
    name: "Pasta al Pesto",
    description: "Pasta al Pesto is a traditional Italian pasta dish that's simple, delicious, and easy to make. The authentic recipe calls for basil, garlic, pine nuts, Parmesan cheese, and olive oil. So simple, so easy!",
  ),
  Recipe(
    name: "Pasta al Ragu",
    description: "Pasta al Ragu is a traditional Italian pasta dish that's savory, rich, and easy to make. The authentic recipe calls for tomatoes, beef, pork, and pancetta. So simple, so easy!",
  ),
];

final mockCategories = [
  "Pasta",
  "Pizza",
  "Salad",
  "Soup",
  "Dessert",
  "Appetizer",
  "Main Course",
  "Side Dish",
  "Beverage",
  "Breakfast",
  "Lunch",
  "Dinner",
  "Snack",
  "Vegetarian",
  "Vegan",
  "Pescatarian",
  "Gluten-Free",
  "Dairy-Free",
  "Nut-Free",
];