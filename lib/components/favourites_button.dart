import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FavouritesButton extends StatelessWidget {
  final String recipeId;
  final int count;
  final double maxWidth;
  final bool isFilled;
  final Function()? onPressed;

  const FavouritesButton({super.key, required this.recipeId, required this.count, this.maxWidth = 100.0, this.isFilled = false, this.onPressed});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(240),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(28.0), bottomLeft: Radius.circular(30.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: PhosphorIcon(isFilled ? PhosphorIconsFill.star : PhosphorIconsRegular.star, color: Theme.of(context).colorScheme.onSecondaryContainer,),
          ),
          SizedBox(width: 1.0),
          Text(count.toString(), style: Theme.of(context).textTheme.bodyMedium,),
        ],
      ),
    );
  }
}