import 'package:flutter/material.dart';
import 'package:scarpetta/themes/main_theme.dart';
import 'package:scarpetta/components/adaptive_navigator.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/util/navigation_target.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdaptiveNavigator(
          routes: NavigationTarget.allTargets(), 
          body: const Text("Hello, World!"), 
          navigationShell: navigationShell
        );
      },
      branches: [
        for (var target in NavigationTarget.allTargets())
          StatefulShellBranch(routes: [
            GoRoute(path: target.route, builder: (context, state) => Text(target.label),)
          ])
      ]
    )
  ]
);

main() {
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