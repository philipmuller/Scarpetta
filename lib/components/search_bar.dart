import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SCSearchBar extends StatelessWidget {
  final bool expanded;

  const SCSearchBar({super.key, this.expanded = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Hero(
            tag: 'searchBackground',
            child: Container(
              height: expanded ? 200 : double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(37.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(expanded ? 0.0 : 0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: expanded 
            ? const EdgeInsets.symmetric(vertical: 35.0) 
            : const EdgeInsets.only(left: 35.0, right: 24.0, bottom: 10.0, top: 10.0),
            child: Flex(
              direction: expanded ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: expanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'searchTitle',
                      child: Text(
                        "What are you cooking?", 
                        style: !expanded 
                        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
                        : Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    if (!expanded)
                      Text("All Categories · Any Duration · Any Ingredients", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey.shade400),)
                  ],
                ),
                if (!expanded)
                  const Spacer(),
                if (!expanded)
                  const Hero(
                    tag: 'searchIcon',
                    child: PhosphorIcon(PhosphorIconsBold.magnifyingGlass)
                  ),
                if (expanded)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        width: 2.0,
                        color: Colors.grey.shade300
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Search by recipe name...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Hero(
                          tag: 'searchIcon',
                          child: const PhosphorIcon(PhosphorIconsBold.magnifyingGlass)
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ], 
      ),
    );
  }
}