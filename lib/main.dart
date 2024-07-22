import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scarpetta/themes/main_theme.dart';
import 'package:scarpetta/util/router.dart';
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
    router.refresh();
  });

  runApp(const ProviderScope(child: Scarpetta()));
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