import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/model/ingredient.dart';
import 'package:scarpetta/model/unit.dart';
import 'package:scarpetta/model/recipe_step.dart';
import 'package:scarpetta/model/duration.dart';

class CookbookService {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Recipe?> getRecipe(String id) async {
    print("CookbookService.getRecipe($id)");
    final recipeMap = await _firestore.collection('recipes').doc(id).get();
    if (!recipeMap.exists) return null;
    return Recipe.fromMap(map: recipeMap.data()!, id: recipeMap.id);
  }

  static deleteRecipe(String id) async {
    print("CookbookService.deleteRecipe($id)");
    await _firestore.collection('recipes').doc(id).delete();
  }

  static Future<Recipe> getFeaturedRecipe() async {
    print("CookbookService.getFeaturedRecipe()");
    final recipes = await CookbookService.getRecipes();
    if (recipes.isEmpty) return mockRecipes[0];
    return recipes[0];
  }

  static favouriteRecipe(String userId, String recipeId) async {
    print("CookbookService.favouriteRecipe($userId)");
    final user = await _getUserInformation(userId);
    user.reference.update({
      'favourites': FieldValue.arrayUnion([recipeId])
    });
  }

  static unFavouriteRecipe(String userId, String recipeId) async {
    print("CookbookService.favouriteRecipe($userId)");
    final user = await _getUserInformation(userId);
    user.reference.update({
      'favourites': FieldValue.arrayRemove([recipeId])
    });
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> _getUserInformation(String userId) async {
    print("CookbookService._getUserInformation($userId)");
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (user.exists == false) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'favourites': [],
        'creations': [],
      });
      user = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    }
    return user;
  }

  static Future<Map<String, dynamic>> getUserInformation(String userId) async {
    print("CookbookService.getUserInformation($userId)");
    final user = await _getUserInformation(userId);
    return user.data()!;
  }

  static addRecipe(Recipe recipe) async {
    print("CookbookService.addRecipe($recipe)");
    final newRecipe = await FirebaseFirestore.instance.collection('recipes').add(recipe.toMap(includeId: false));
    if (recipe.authorId == null) return;

    final user = await _getUserInformation(recipe.authorId!);
    print(user.data());
    user.reference.update({
      'creations': FieldValue.arrayUnion([newRecipe.id])
    });
  }

  static updateRecipe({required Recipe recipe, String? id}) async {
    print("CookbookService.updateRecipe($recipe, $id)");
    await FirebaseFirestore.instance.collection('recipes').doc(id ?? recipe.id).update(recipe.toMap(includeId: false));
  }

  static Future<List<Recipe>> getRecipes({String? categoryId, String? authorId, List<String>? favouritedByUser}) async {
    print("CookbookService.getRecipes($categoryId)");
    //print("Retreiving recipes...");
    Query<Map<String, dynamic>> query;
    final category = await _firestore.collection('categories').doc(categoryId).get();

    query = _firestore.collection('recipes').where('name', isGreaterThanOrEqualTo: '');
    if (categoryId != null) query = query.where('categories', arrayContains: category.data()!['name']);
    if (authorId != null) query = query.where('authorId', isEqualTo: authorId);
    if (favouritedByUser != null) query = query.where(FieldPath.documentId, whereIn: favouritedByUser);
    final snapshot = await query.get();

    final recipes = snapshot.docs.map((doc) {
      //print(doc.data());
      final recipe = Recipe.fromMap(map: doc.data(), id: doc.id);
      return recipe;
    }).toList();

    //print("Recipes retreived: $recipes");

    return recipes;
  }

  static Future<List<Category>> getCategories() async {
    print("CookbookService.getCategories()");
    //print("Retreiving categories...");
    final snapshot = await _firestore.collection('categories').get();

    final categories = snapshot.docs.map((doc) {
      final category = Category.fromMap(map: doc.data(), id: doc.id);
      //print(category.name);
      return category;
    }).toList();

    //print("Categories retreived: $categories");
    return categories;
  }

  static Future<Category> getCategory(String id) async {
    print("CookbookService.getCategory($id)");
    //print("Retreiving categories...");
    final snapshot = await _firestore.collection('categories').doc(id).get();
    final category = Category.fromMap(map: snapshot.data()!, id: snapshot.id);
    print(category);

    //print("Categories retreived: $categories");
    return category;
  }

  static Stream<List<Recipe>> findRecipes(String query) {
    print("CookbookService.findRecipes($query)");
    final stream = _firestore
        .collection('recipes')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Recipe.fromMap(map: doc.data(), id: doc.id)).toList());

    return stream;
  }

}

final mockRecipes = [
  Recipe(
    name: "Pasta Carbonara",
    description: "Pasta Carbonara is a classic Italian pasta dish that's creamy, rich, and easy to make! The authentic recipe calls for eggs, pancetta, cheese, and pepper. So simple, so easy!",
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