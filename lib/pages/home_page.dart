import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/add_recipe_button.dart';
import 'package:scarpetta/components/featured_card.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/components/sc_app_bar.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/providers&state/categories_provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_categories.dart';

class HomePage extends StatefulWidget {
  Function(int)? switchTab;

  HomePage({super.key, this.switchTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double topPadding = 60.0;

  final double xPadding = 30.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final providerR = Provider.of<RecipeProvider>(context, listen: false);
      final providerC = Provider.of<CategoryProvider>(context, listen: false);
      providerR.fetchFeaturedRecipe();
      providerC.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context){
    final session = Provider.of<SessionProvider>(context);

    double width = MediaQuery.of(context).size.width;
    bool isMobile = true;
    bool isDesktop = false;

    if (width > Breakpoint.md) {
      isMobile = false;
    }
    if (width > Breakpoint.lg) {
      isDesktop = true;
    }


    return Scaffold(
      appBar: SCAppBar(title: "Home", transparent: true,),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: session.isLoggedIn && isMobile
        ? const AddRecipeButton()
        : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<RecipeProvider>(
                builder: (context, recipeProvider, child) {
                  if (recipeProvider.featuredRecipe == null) {
                    return FeaturedCard(recipe: Recipe(name: "Loading", description: "..."));
                  }
                  return FeaturedCard(recipe: recipeProvider.featuredRecipe!);
                }
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text("Categories", style: Theme.of(context).textTheme.headlineSmall),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        if (isDesktop) {
                          //Navigator.of(context).('/recipes');
                          return;
                        }
                        openCategories(
                          context: context, 
                          isMobile: isMobile, 
                        );
                      },
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  if (categoryProvider.categoryMap.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: categoryProvider.categoryMap.values
                        .take(isDesktop ? 10 : 6)
                        .map((category) => Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: CategoryIndicator(category: category, push: true,),
                        ))
                        .toList()
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}