import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/services/cookbook_service.dart';

import '../model/recipe.dart';

class SCSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const PhosphorIcon(PhosphorIconsRegular.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget _buildRecipeResults(BuildContext context, List<Recipe> recipes) {
    if (recipes.isEmpty) {
      return const Center(
        child: Text('No results found.'),
      );
    }

    return RecipesGrid(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      recipes: recipes,
      onRecipeTap: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: SizedBox(height: 10),
      );
    }

    return StreamBuilder<List<Recipe>>(
      stream: CookbookService.findRecipes(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildRecipeResults(context, snapshot.data!);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: CookbookService.findRecipes(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator()
          );
        }

        return _buildRecipeResults(context, snapshot.data!);
      },
    );
  }
  
}