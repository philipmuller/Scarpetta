import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  bool _isLoggedIn = FirebaseAuth.instance.currentUser != null;
  bool get isLoggedIn => _isLoggedIn;

  User? _user = FirebaseAuth.instance.currentUser;
  User? get user => _user;


  void login() {
    FirebaseAuth.instance.signInAnonymously();
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }
}