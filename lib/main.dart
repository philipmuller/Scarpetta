import 'package:flutter/material.dart';
import 'package:scarpetta/themes/main_theme.dart';
import 'package:scarpetta/components/adaptive_navigator.dart';

main() {
  runApp(const Scarpetta());
}

class Scarpetta extends StatelessWidget {
  const Scarpetta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scarpetta",
      theme: const MainTheme().toThemeData(),
      home: const AdaptiveNavigator(
        routes: ["/home", "/about", "/contact", "/settings"], 
        body: Text("Hello, World!")
      )
    );
  }
}