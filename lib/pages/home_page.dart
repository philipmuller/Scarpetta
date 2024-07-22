import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/featured_card.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/providers&state/categories_provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_categories.dart';

final mockCategories = [
  "Breakfast",
  "Lunch",
  "Dinner",
  "Dessert",
  "Snacks",
  "Drinks",
];

class HomePage extends ConsumerWidget {
  final double topPadding = 65.0;
  final double xPadding = 30.0;

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final recipes = ref.watch(recipesProvider);
    final featuredRecipe = recipes.value?[0];

    double width = MediaQuery.of(context).size.width;
    bool mobileModal = true;
    bool isDesktop = false;

    if (width > Breakpoint.md) {
      mobileModal = false;
    }
    if (width > Breakpoint.lg) {
      isDesktop = true;
    }


    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedCard(recipe: featuredRecipe ?? Recipe(name: "Loading...", description: "Loading...")),
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
                        context.go('/recipes');
                        return;
                      }

                      openCategories(
                        context: context, 
                        isMobile: mobileModal, 
                      );
                    },
                    child: const Text("See all"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 8.0),
              child: categories.when(
                data: (state) => Row(
                  children: state
                    .take(isDesktop ? 10 : 6)
                    .map((category) => Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CategoryIndicator(category: category, push: true,),
                    ))
                    .toList()
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ), 
            )
          ],
        ),
      ),
    );
  }
}