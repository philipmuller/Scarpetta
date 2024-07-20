import 'package:flutter/material.dart';
import 'package:scarpetta/themes/main_theme.dart';
import 'package:scarpetta/util/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const Scarpetta());
}

class Scarpetta extends StatelessWidget {
  const Scarpetta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Scarpetta",
      theme: const MainTheme().toThemeData(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}