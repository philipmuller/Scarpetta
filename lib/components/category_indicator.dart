import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/category.dart';

class CategoryIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final Category category;
  final Function(Category)? onTap;
  final bool push;

  const CategoryIndicator({super.key, this.size = 100.0, this.color = Colors.pink, required this.category, this.onTap, this.push = false});

  @override
  Widget build(BuildContext context) {
    //print("Category indicator: $name");
    return GestureDetector(
      onTap: () {
        onTap?.call(category);
        if (push) {
          print("PUSH IS TRUE");
          print("About to push to /recipes/categories/${category.id}");
          if (context.canPop()) {
            context.pop();
          }
          context.replace("/recipes/categories/${category.id}");
        }
      },
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SCImage(imageUrl: category.imageUrl, height: size, width: size),
          ),
          const SizedBox(height: 10.0),
          Text(category.name, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}