import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/components/featured_card.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/categories_page.dart';
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
  final double topPadding = 65.0;
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
            FeaturedCard(recipe: CookbookService.getFeaturedRecipe()),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text("Categories", style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useRootNavigator: false,
                        useSafeArea: true,
                        enableDrag: true,
                        showDragHandle: true,
                        context: context, 
                        builder: (context) {
                          return CategoriesPage(
                            key: UniqueKey(),
                            onCategoryTap: (category) {
                              GoRouter.of(context).pop();
                            },
                            push: true,
                          );
                        }
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
              child: FutureBuilder(
                future: CookbookService.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Row(
                    children: snapshot.data!
                      .take(6)
                      .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: CategoryIndicator(category: category, push: true,),
                      ))
                      .toList()
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}