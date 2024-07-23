import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/providers&state/categories_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';

class CategoriesPage extends StatelessWidget {
  final Function(Category)? onCategoryTap;
  final bool push;

  const CategoriesPage({super.key, this.onCategoryTap, this.push = false});

  @override
  Widget build(BuildContext context){//, WidgetRef ref) {
    //final state = ref.watch(categoriesProvider);

    double width = MediaQuery.of(context).size.width;
    double topPadding = 30.0;
    double xPadding = 30.0;
    int gridColumns = 3;
    bool isDesktop = false;
    if (width > Breakpoint.lg) {
      if (push) {
        gridColumns = 2;
      }
      xPadding = 10.0;
      isDesktop = true;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Categories"),
        centerTitle: true,
        actions: [
          if (!isDesktop || !push)
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsRegular.x),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
        crossAxisCount: gridColumns,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        // children: state.when(
        //   data: (state) => state.map((category) {
        //     return CategoryIndicator(
        //       category: category,
        //       onTap: onCategoryTap,
        //       push: push,
        //     );
        //   }).toList(),
        //   loading: () => [const Center(child: CircularProgressIndicator())],
        //   error: (error, stack) => [Center(child: Text('Error: $error'))],
        // ),
      ),
    );
  }
}