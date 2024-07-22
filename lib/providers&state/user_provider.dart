import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class UserProvider extends AsyncNotifier<Map<String, dynamic>?> {

  @override
  Future<Map<String, dynamic>?> build() async {
    print("UserProvider build()");
    if (FirebaseAuth.instance.currentUser == null) { return null; }
    final user = await CookbookService.getUserInformation(FirebaseAuth.instance.currentUser!.uid);
    state = AsyncValue.data(user);
    return user;
  }

  void fetchUser() async {
    print("UserProvider fetchUser()");
    if (FirebaseAuth.instance.currentUser == null) { return; }
    final user = await CookbookService.getUserInformation(FirebaseAuth.instance.currentUser!.uid);
    print("user $user");
    //cachedCategories = categories;
    state = AsyncValue.data(user);
  }

  void favouriteRecipe(String recipeId) async {
    print("UserProvider favouriteRecipe($recipeId)");
    final user = state.value;
    user?['favourites'].add(recipeId);
    state = AsyncValue.data(user);
    if (FirebaseAuth.instance.currentUser == null) { return; }
    await CookbookService.favouriteRecipe(FirebaseAuth.instance.currentUser!.uid, recipeId);
  }

  void unFavouriteRecipe(String recipeId) async {
    print("UserProvider unFavouriteRecipe($recipeId)");
    final user = state.value;
    user?['favourites'].remove(recipeId);
    state = AsyncValue.data(user);
    if (FirebaseAuth.instance.currentUser == null) { return; }
    await CookbookService.unFavouriteRecipe(FirebaseAuth.instance.currentUser!.uid, recipeId);
  }

  void createRecipe(String recipeId) async {
    print("UserProvider createRecipe($recipeId)");
    final user = state.value;
    user?['creations'].add(recipeId);
    state = AsyncValue.data(user);
    fetchUser();
  }
  
}

final userProvider = AsyncNotifierProvider<UserProvider, Map<String, dynamic>?>(() {
  return UserProvider();
});