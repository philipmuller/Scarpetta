import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/components/sc_app_bar.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/providers&state/categories_provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/selected_category_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/components/recipe_card.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_categories.dart';

class RecipesPage extends StatefulWidget {
  final String? categoryId;
  final Category? category;

  const RecipesPage({super.key, this.categoryId, this.category});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final double topPadding = 10.0;
  final double xPadding = 30.0;

  @override
  void initState() {
    print("STATE RELOADED");
    super.initState();
    Future.microtask(() async {
      // ref.read(recipeProvider.notifier).fetchRecipes();
      // ref.read(recipeProvider.notifier).filterByCategory(widget.categoryId);
      if (widget.categoryId != null) {
        final category = await CookbookService.getCategory(widget.categoryId!);
        //ref.read(selectedCategoryProvider.notifier).update((state) => state = category.name);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //final recipes = ref.watch(recipesProvider);
    //final selectedCategory = ref.watch(selectedCategoryProvider);

    double width = MediaQuery.of(context).size.width;
    bool mobileModal = true;
    bool isDesktop = false;
    if (width > Breakpoint.md) {
      mobileModal = false;
    }
    if (width > Breakpoint.lg) {
      isDesktop = true;
    }

    return Row(
      children: [
        Expanded(
          child: Scaffold(
            appBar: SCAppBar(title: widget.category?.name ?? "Recipes"),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: (!isDesktop)
              ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    openCategories(
                      context: context, 
                      isMobile: mobileModal, 
                      push: true,
                    );
                  }, 
                  label: const Text('Categories'),
                  icon: const PhosphorIcon(PhosphorIconsRegular.squaresFour),
                ),
              )
              : null,
            body: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: RecipesGrid(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  //recipes: state,
                ),
            ),
          ),
        ),
        if (isDesktop)
          const VerticalDivider(width: 1),
        if (isDesktop)
          Container(
            width: 300,
            child: CategoriesPage(push: true)
          )
      ],
    );
  }
}