import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NavigationTarget {
  final String route;
  final PhosphorIcon icon;
  final String label;

  NavigationTarget({required this.route, required this.icon, required this.label});

  static List<NavigationTarget> allTargets() {
    return [
      NavigationTarget(route: "/", icon: const PhosphorIcon(PhosphorIconsBold.houseSimple), label: "Home"),
      NavigationTarget(route: "/recipes", icon: const PhosphorIcon(PhosphorIconsBold.rows), label: "Recipes"),
      NavigationTarget(route: "/settings", icon: const PhosphorIcon(PhosphorIconsBold.gear), label: "Settings"),
    ];
  }
}