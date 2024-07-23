import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/recipe_card.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';

class RecipesGrid extends StatefulWidget {
  final List<Recipe>? recipes;
  final EdgeInsets? padding;
  final Function()? onRecipeTap;

  RecipesGrid({super.key, this.recipes, this.padding, this.onRecipeTap});

  @override
  State<RecipesGrid> createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  final int _pageSize = 10;

  final PagingController<String?, Recipe> _pagingController = PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }


  Future<void> _fetchPage(String? pageKey) async {
    try {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      final newItems = await provider.fetchRecipes(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newItems.last.id;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int numberOfColumns = 1;
    double mainAxisSpacing = 40;
    double crossAxisSpacing = 10;
    if (width > Breakpoint.md) {
      numberOfColumns = 2;
      mainAxisSpacing = 30;
      crossAxisSpacing = 30;
    }
    // if (width > Breakpoint.lg) {
    //   numberOfColumns = 3;
    //   mainAxisSpacing = 40;
    //   crossAxisSpacing = 40;
    // }

    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: PagedGridView(
            pagingController: _pagingController,
            clipBehavior: Clip.none,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numberOfColumns,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: 0.9,
            ),
            padding: widget.padding,
            builderDelegate: PagedChildBuilderDelegate<Recipe>(
              itemBuilder: (context, recipe, index) {
                return RecipeCard(recipe: recipeProvider.recipesMap['id'] ?? recipe, onTap: widget.onRecipeTap);
              },
            )
          ),
        );
      } 
    );
  }
}