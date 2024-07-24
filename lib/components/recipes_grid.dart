import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/recipe_card.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/recipe_page.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';

class RecipesGrid extends StatefulWidget {
  final List<Recipe>? recipes;
  final EdgeInsets? padding;
  final Function()? onRecipeTap;
  final Category? categoryFilter;
  final bool filterFavourites;
  final bool filterCreatedByUser;

  RecipesGrid({super.key, this.recipes, this.padding, this.onRecipeTap, this.categoryFilter, this.filterFavourites = false, this.filterCreatedByUser = false});

  @override
  State<RecipesGrid> createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  final int _pageSize = 10;

  final PagingController<String?, Recipe> _pagingController = PagingController(firstPageKey: null);
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
        recipeProvider.newRecipeStream.listen((_) {
          _refreshList();
        });
        if (widget.filterFavourites) {
          sessionProvider.favouritesStream.listen((_) {
            _refreshList();
          });
        }
      }
    );
  }

  Future<void> _fetchPage(String? pageKey) async {
    try {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      List<String>? favouritedByUser;
      String? userId;
      if (widget.filterFavourites) {
        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
        favouritedByUser = sessionProvider.userFavourites;
      }
      if (widget.filterCreatedByUser) {
        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
        userId = sessionProvider.user?.uid;
      }

      final newItems = (favouritedByUser?.isNotEmpty ?? false) || favouritedByUser == null
      ? await provider.fetchRecipes(pageKey, _pageSize, widget.categoryFilter, userId, favouritedByUser)
      : <Recipe>[];
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

  void _refreshList() {
    _pagingController.refresh();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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

    if (widget.recipes != null) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numberOfColumns,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: 0.9,
        ),
        padding: widget.padding,
        itemCount: widget.recipes!.length,
        itemBuilder: (context, index) {
          return RecipeCard.withRecipe(recipe: widget.recipes![index], onTap: widget.onRecipeTap);
        },
      );
    }

    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: PagedGridView(
            pagingController: _pagingController,
            scrollController: _scrollController,
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
                final sessionProvider = Provider.of<SessionProvider>(context, listen: true);
                return RecipeCard.withDetails(
                  name: recipeProvider.recipesMap[recipe.id]?.name ?? recipe.name,
                  description: recipeProvider.recipesMap[recipe.id]?.description ?? recipe.description,
                  imageUrl: recipeProvider.recipesMap[recipe.id]?.imageUrl ?? recipe.imageUrl,
                  favouriteCount: recipeProvider.recipesMap[recipe.id]?.favouriteCount ?? recipe.favouriteCount,
                  recipeId: recipe.id,
                  isFavourite: sessionProvider.userFavourites.contains(recipe.id),
                  onTap: () {
                    widget.onRecipeTap?.call();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipeProvider.recipesMap[recipe.id] ?? recipe)));
                  },
                  onFavouriteTapped: () {
                    if (sessionProvider.isLoggedIn) {
                      if (sessionProvider.userFavourites.contains(recipe.id)) {
                        sessionProvider.removeFavourite(recipe.id);
                        recipeProvider.removeFavourite(recipe.id);

                      } else {
                        sessionProvider.addFavourite(recipe.id);
                        recipeProvider.addFavourite(recipe.id);
                      }
                    }
                  },
                );
              },
            )
          ),
        );
      } 
    );
  }
}