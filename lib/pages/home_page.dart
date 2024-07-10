import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/components/featured_card.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/services/cookbook_service.dart';

final mockCategories = [
  "Breakfast",
  "Lunch",
  "Dinner",
  "Dessert",
  "Snacks",
  "Drinks",
];

class HomePage extends StatelessWidget {
  final double topPadding = 60.0;
  final double xPadding = 30.0;

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedCard(recipe: CookbookService.featuredRecipe()),
            const SizedBox(height: 30),
            Row(
              children: [
                Text("Categories", style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push("/recipes/categories");
                  },
                  child: const Text("See all"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mockCategories
                  .map((categoryName) => Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CategoryIndicator(name: categoryName),
                  ))
                  .toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}