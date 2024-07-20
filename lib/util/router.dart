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

final _homeKey = GlobalKey<NavigatorState>();
final _recipesKey = GlobalKey<NavigatorState>();
final _profileKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdaptiveNavigator(
          routes: _navigatorTargets,
          state: state,
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
    route: "/profile", 
    icon: const PhosphorIcon(PhosphorIconsBold.user), 
    label: "Profile",
    ),
];

//these are all branches shown by the Adaptive Navigator
final _navigatorBranches = [
  StatefulShellBranch(
    navigatorKey: _homeKey,
    routes: [
      GoRoute(
        parentNavigatorKey: _homeKey,
        name: "home",
        path: '/',
        builder: (context, state) {
          return const HomePage();
        }
      )
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _recipesKey,
    routes: [
      GoRoute(
        parentNavigatorKey: _recipesKey,
        name: "recipes",
        path: '/recipes',
        builder: (context, state) {
          return const RecipesPage();
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _recipesKey,
            name: "recipe category",
            path: 'categories/:id',
            builder: (context, state) {
              final categoryId = state.pathParameters['id'] ?? "";
              if (categoryId == "") return const RecipesPage();
              print("About to show category page with id: $categoryId");
              return RecipesPage(categoryId: categoryId, key: UniqueKey(),);
            }
          ),
          // GoRoute(
          //   name: "recipe categories",
          //   path: '/recipes/categories',
          //   builder: (context, state) {
          //     return const CategoriesPage();
          //   }
          // ),
          GoRoute(
            parentNavigatorKey: _recipesKey,
            name: "recipe",
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? "";
              return RecipePage(recipeId: id);
            }
          ),
        ],
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _profileKey,
    routes: [
      GoRoute(
        parentNavigatorKey: _profileKey,
        name: "profile",
        path: '/profile',
        builder: (context, state) {
          return const Text("Profile page");
        }
      )
    ],
  ),
];

//this is the final list of branches that the GoRouter will use
final _branches = [
  ..._navigatorBranches,
];