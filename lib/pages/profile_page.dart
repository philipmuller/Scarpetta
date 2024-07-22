import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/pages/my_favourites_page.dart';
import 'package:scarpetta/pages/my_recipes_page.dart';
import 'package:scarpetta/pages/recipes_page.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Recipes', icon: PhosphorIcon(PhosphorIconsRegular.chefHat),),
              Tab(text: 'Favourites', icon: PhosphorIcon(PhosphorIconsRegular.star)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            //RecipesGrid(recipes: recipes),
            MyRecipesPage(),
            MyFavouritesPage(),
          ],
        ),
      ),
    );
  }
}