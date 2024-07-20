import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/components/recipe_card.dart';

class RecipesPage extends StatefulWidget {
  final double topPadding = 55.0;
  final double xPadding = 30.0;
  final Category? category;
  final String? categoryId;

  const RecipesPage({super.key, this.category, this.categoryId});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  Category? _filteredCategory;

  @override
  void initState() {
    super.initState();
    _filteredCategory = widget.category;
    if (widget.categoryId != null) {
      _findCategoryName(widget.categoryId!);
    }
  }

  void _findCategoryName(String id) async {
    final category = await CookbookService.getCategory(id);
    setState(() {
      _filteredCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: widget.topPadding),
          child: FutureBuilder(
            future: CookbookService.getRecipes(categoryId: _filteredCategory?.id), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
          
              final recipes = snapshot.data as List<Recipe>;
              return RecipesGrid(
                categoryId: _filteredCategory?.id,
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                recipes: recipes
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                useRootNavigator: false,
                enableDrag: true,
                useSafeArea: true,
                showDragHandle: true,
                context: context, 
                builder: (context) {
                  return CategoriesPage(
                    push: true,
                    key: UniqueKey(),
                    onCategoryTap: (category) {
                      GoRouter.of(context).pop();
                      // setState(() {
                        
                      // _filteredCategory = category;
                      // });
                  });
                }
              );
            }, 
            label: const Text('Categories'),
            icon: const PhosphorIcon(PhosphorIconsRegular.squaresFour),
          ),
        ),

        if (_filteredCategory != null)
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
                    Text(
                      _filteredCategory?.name ?? "",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500
                      )
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).go('/recipes');
                      }, 
                      icon: const PhosphorIcon(PhosphorIconsRegular.x, size: 20),
                    )
                  ],
                )
              )
            ),
          ),
      ],
    );
  }
}