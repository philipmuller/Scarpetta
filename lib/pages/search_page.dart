import 'package:flutter/material.dart';

final mockData = [
  "Pasta al pomodoro",
  "Pasta al pesto",
  "Aglio, oglio, peperoncino",
  "Parmigiana di melanzane",
  "Pizza margherita",
  "Tiramisù",
  "Gelato",
];

class SearchPage extends StatelessWidget {
  final String query;
  final double topPadding = 60.0;
  final double xPadding = 30.0;

  const SearchPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
      children: mockData
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .map((e) => ListTile(title: Text(e)))
        .toList(),
    );
  }
}