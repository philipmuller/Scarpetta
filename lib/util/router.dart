import 'package:flutter/material.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/pages/category_page.dart';
import 'package:scarpetta/pages/recipe_page.dart';
import 'package:scarpetta/components/adaptive_navigator.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/pages/recipes_page.dart';
import 'package:scarpetta/util/navigator_target.dart';
import 'package:scarpetta/pages/search_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/pages/home_page.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdaptiveNavigator(
          routes: _navigatorTargets, 
          body: const Text("Hello, World!"), 
          navigationShell: navigationShell
        );
      },
      branches: _branches
    )
  ]
);

//navigator targets are compact data classes that hold the route, icon, and label for each navigation item displayed by the Adaptive Navigator
final List<NavigatorTarget> _navigatorTargets = [
  NavigatorTarget(
    route: "/", 
    icon: const PhosphorIcon(PhosphorIconsBold.houseSimple), 
    label: "Home",
  ),
  NavigatorTarget(
    route: "/recipes", 
    icon: const PhosphorIcon(PhosphorIconsBold.forkKnife), 
    label: "Recipes",
  ),
  NavigatorTarget(
    route: "/calendar", 
    icon: const PhosphorIcon(PhosphorIconsBold.calendarDots), 
    label: "Calendar",
    ),
];

//these are all branches shown by the Adaptive Navigator
final _navigatorBranches = [
  StatefulShellBranch(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomePage();
        }
      )
    ],
  ),
  StatefulShellBranch(routes: [
      GoRoute(
        path: '/recipes',
        builder: (context, state) {
          return const RecipesPage();
        }
      ),
      GoRoute(
        path: '/recipes/categories/:name',
        builder: (context, state) {
          final categoryName = state.pathParameters['name'] ?? "";
          return CategoryPage(categoryName: categoryName);
        }
      ),
      GoRoute(
        path: '/recipes/categories',
        builder: (context, state) {
          return const CategoriesPage();
        }
      ),
      GoRoute(
        path: '/recipes/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? "";
          return RecipePage(recipeId: id);
        }
      ),
    ],
  ),
  StatefulShellBranch(routes: [
      GoRoute(
        path: '/calendar',
        builder: (context, state) {
          return const Text("Calendar");
        }
      )
    ],
  ),
];

//this is the final list of branches that the GoRouter will use
final _branches = [
  ..._navigatorBranches,
  StatefulShellBranch(routes: [
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? "";
          return SearchPage(query: query);
        }
      )
    ]
  )
];