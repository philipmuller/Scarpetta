import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/adaptive_navigator.dart';
import 'package:scarpetta/providers&state/categories_provider.dart';
import 'package:scarpetta/providers&state/navigation_state_provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/themes/main_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    print("Auth changed: $user");
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => recipeProvider),
      ChangeNotifierProvider(create: (_) => categoryProvider),
      ChangeNotifierProvider(create: (_) => navigationStateProvider)
    ],
    child: Scarpetta()
  ));
}

class Scarpetta extends StatelessWidget {
  const Scarpetta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scarpetta",
      theme: const MainTheme().toThemeData(),
      debugShowCheckedModeBanner: false,
      home: const AdaptiveNavigator(),
    );
  }
}