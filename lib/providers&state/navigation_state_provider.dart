import 'package:flutter/material.dart';

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0;
  List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void navigateToRoute(int tabIndex, Route<dynamic> route) {
    setIndex(tabIndex);
    navigatorKeys[tabIndex].currentState?.push(route);
  }

  void popNavigator(int tabIndex) {
    navigatorKeys[tabIndex].currentState?.pop();
  }
}