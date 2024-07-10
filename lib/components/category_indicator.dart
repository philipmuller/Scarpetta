import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final String name;

  const CategoryIndicator({super.key, this.size = 100.0, this.color = Colors.pink, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/recipes/categories/${name}');
      },
      child: Column(
        children: [
          CircleAvatar(radius: size/2),
          const SizedBox(height: 10.0),
          Text(name, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}