import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SCAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const SCAppBar({super.key, this.title = "Scarpetta"});

  //mediaquery to get full height of screen

  @override
  State<SCAppBar> createState() => _SCAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SCAppBarState extends State<SCAppBar> {
  bool isSearching = false;
  //String _query = "";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: _searchBar(),
    );
  }

// Flexible(
//   child: TextField(
//     decoration: const InputDecoration(
//       hintText: "What are we cooking?",
//       border: InputBorder.none,
//     ),
//     onChanged: _onQueryChanged,
//   ),
// ),

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: Expanded(
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: RecipeSearch());
          },
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.only(left: 35.0, right: 12.0, bottom: 10.0, top: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("What are you cooking?", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2.0),
                      Text("All Categories · Any Duration · Any Ingredients", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey.shade400),)
                    ],
                  ),
                ),
                //const Spacer(),
                IconButton(
                  icon: isSearching
                  ? const PhosphorIcon(PhosphorIconsBold.x)
                  : const PhosphorIcon(PhosphorIconsBold.magnifyingGlass),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
            
                      if (!isSearching) {
                        GoRouter.of(context).go('/'); //this is not good, it needs to pop back to previous instead of home
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecipeSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }
}