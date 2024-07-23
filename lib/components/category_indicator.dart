import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/recipes_page.dart';
import 'package:scarpetta/providers&state/navigation_state_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';

class CategoryIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final Category category;
  final Function(Category)? onTap;
  final bool push;

  const CategoryIndicator({super.key, this.size = 100.0, this.color = Colors.pink, required this.category, this.onTap, this.push = false});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final isMobile = width < Breakpoint.md;
    //print("Category indicator: $name");
    return GestureDetector(
      onTap: () {
        onTap?.call(category);
        if (push) {
          print("PUSH IS TRUE");
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          //Provider.of<NavigationState>(context, listen: false).setIndex(1);
          Provider.of<NavigationState>(context, listen: false).navigateToRoute(1, MaterialPageRoute(builder: (context) => RecipesPage(category: category,)));
          //Navigator.of(context).replace("/recipes/categories/${category.id}");
        }
      },
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SCImage(imageUrl: category.imageUrl, height: isMobile ? 80 : size, width: isMobile ? 80 : size),
          ),
          const SizedBox(height: 10.0),
          Text(category.name, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}