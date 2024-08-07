import 'package:flutter/material.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/pages/recipe_page.dart';

class FeaturedCard extends StatelessWidget {
  final Recipe recipe;
  const FeaturedCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)));
        //Provider.of<NavigationState>(context, listen: false).navigateToRoute(1, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)));
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: (height*0.60),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Change shadow color with opacity
              spreadRadius: 10, // Spread radius of the shadow
              blurRadius: 10, // Blur radius of the shadow
              offset: Offset(0, 0), // Position of the shadow
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SCImage(imageUrl: recipe.imageUrl),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7), // Gradient start color
                    Colors.transparent, // Gradient end color
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "FEATURED", 
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      letterSpacing: 3, 
                      color: Theme.of(context).colorScheme.surface,
                    )),
                  Text(recipe.name, 
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface
                    )
                  )
                ],
              ),
            )
          ]
        )
      ),
    );
  }
}