import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NavigatorTarget {
  final String route;
  final PhosphorIcon icon;
  final String label;

  NavigatorTarget({required this.route, required this.icon, required this.label});
}