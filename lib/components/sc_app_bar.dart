import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SCAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const SCAppBar({super.key, this.title = "Scarpetta"});

  @override
  State<SCAppBar> createState() => _SCAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SCAppBarState extends State<SCAppBar> {
  bool isSearching = false;
  //String _query = "";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
      ? _searchBar()
      : Text(widget.title),
      actions: [
        IconButton(
          icon: isSearching
          ? const Icon(Icons.clear)
          : const Icon(Icons.search),
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
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search",
        border: InputBorder.none,
      ),
      onChanged: _onQueryChanged,
    );
  }

  void _onQueryChanged(String query) {
    GoRouter.of(context).go('/search?q=$query');
  }
}