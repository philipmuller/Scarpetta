import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scarpetta/model/user_data.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class SessionProvider extends ChangeNotifier {
  bool _isLoggedIn = FirebaseAuth.instance.currentUser != null;
  bool get isLoggedIn => _isLoggedIn;

  User? _user = FirebaseAuth.instance.currentUser;
  User? get user => _user;

  List<String> _userRecipes = [];
  List<String> get userRecipes => _userRecipes;

  List<String> _userFavourites = [];
  List<String> get userFavourites => _userFavourites;

  final StreamController<void> _favouritesController = StreamController<void>.broadcast();
  Stream<void> get favouritesStream => _favouritesController.stream;

  SessionProvider() {
    _initialise();
  }

  _initialise() async {
    if (_user != null) {
      final userData = await CookbookService.getUserData(_user!.uid);
      _userRecipes = userData?.recipes ?? [];
      _userFavourites = userData?.favourites ?? [];
    }
  }

  login() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();

    final userData = await CookbookService.getUserData(credential.user!.uid);
    _user = credential.user;
    _userRecipes = userData?.recipes ?? [];
    _userFavourites = userData?.favourites ?? [];
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    _user = null;
    _userRecipes = [];
    _userFavourites = [];
    _isLoggedIn = false;
    notifyListeners();
  }

  void addFavourite(String recipeId) {
    _userFavourites.add(recipeId);
    notifyListeners();
    _favouritesController.add(null);

    if (_user != null) {
      CookbookService.favouriteRecipe(_user!.uid, recipeId);
    }
  }

  void removeFavourite(String recipeId) {
    _userFavourites.remove(recipeId);
    notifyListeners();
    _favouritesController.add(null);

    if (_user != null) {
      CookbookService.unFavouriteRecipe(_user!.uid, recipeId);
    }
  }
}