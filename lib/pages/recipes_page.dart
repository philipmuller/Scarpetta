import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/providers&state/cookbook_provider.dart';
import 'package:scarpetta/providers&state/cookbook_state.dart';
import 'package:scarpetta/providers&state/recipe_provider.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/components/recipe_card.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_categories.dart';

class RecipesPage extends ConsumerWidget {
  final double topPadding = 55.0;
  final double xPadding = 30.0;
  final String? categoryId;

  const RecipesPage({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Category? category = null;
    final state = ref.watch(cookbookProvider);
    if (categoryId != null) {
      ref.read(cookbookProvider.notifier).filterByCategory(categoryId!);
    }

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
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: state.when(
                  data: (state) => RecipesGrid(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    recipes: state.recipes,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
              if (!isDesktop)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      openCategories(
                        context: context, 
                        isMobile: mobileModal, 
                        push: false, 
                        onCategoryTap: (category) {
                          category = category;
                          ref.read(cookbookProvider.notifier).filterByCategory(category!.id!);
                          Navigator.pop(context);
                        }
                      );
                    }, 
                    label: const Text('Categories'),
                    icon: const PhosphorIcon(PhosphorIconsRegular.squaresFour),
                  ),
                ),
          
              if (categoryId != null)
                Positioned(
                  top: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 5.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          FutureBuilder(
                            future: CookbookService.getCategory(categoryId!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              final filterCategory = snapshot.data as Category;
                              return Text(
                                filterCategory.name ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500
                                )
                              );
                            }
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              //GoRouter.of(context).go('/recipes');
                              ref.read(cookbookProvider.notifier).filterByCategory(null);

                            }, 
                            icon: const PhosphorIcon(PhosphorIconsRegular.x, size: 20),
                          )
                        ],
                      )
                    )
                  ),
                ),
            ],
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