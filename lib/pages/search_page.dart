import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/components/search_bar.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/recipes_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/services/cookbook_service.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Search'),
        tooltip: 'Search',
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RecipesPage(),
          ));
        },
        icon: const PhosphorIcon(PhosphorIconsBold.magnifyingGlass),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SCSearchBar(expanded: true),
            Text('Categories', style: Theme.of(context).textTheme.titleLarge),
            FutureBuilder(
              future: CookbookService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10.0),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: [
                      Category(name: "All"),
                      ...snapshot.data!
                    ].map((category) {
                      return CategoryIndicator(category: category);
                    }).toList(),
                  );
                }

                return const Center(
                  child: Text('No categories found'),
                );
                
              }
            ),
          ],
        ),
      ),
    );
  }
}
