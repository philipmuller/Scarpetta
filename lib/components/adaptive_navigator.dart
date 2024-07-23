//this compoent was inspired by the Adaptive Scaffold from the flutter samples at https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/add_recipe_button.dart';
import 'package:scarpetta/components/auth_button.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/pages/home_page.dart';
import 'package:scarpetta/pages/my_favourites_page.dart';
import 'package:scarpetta/pages/recipes_page.dart';
import 'package:scarpetta/pages/search_page.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/navigator_target.dart';
import 'package:scarpetta/components/search_bar.dart';
import 'package:scarpetta/util/open_add_edit_recipe.dart';
import 'package:scarpetta/util/sc_search_delegate.dart';

class AdaptiveNavigator extends StatefulWidget {

  const AdaptiveNavigator({super.key});

  @override
  State<AdaptiveNavigator> createState() => _AdaptiveNavigatorState();
}

class _AdaptiveNavigatorState extends State<AdaptiveNavigator> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    const HomePage(),
    const RecipesPage(),
    const MyFavouritesPage(),
  ];

  final List<NavigatorTarget> _targets = const [
    NavigatorTarget(
      icon: PhosphorIcon(PhosphorIconsRegular.house),
      label: "Home"
    ),
    NavigatorTarget(
      icon: PhosphorIcon(PhosphorIconsRegular.forkKnife),
      label: "Recipes"
    ),
    NavigatorTarget(
      icon: PhosphorIcon(PhosphorIconsRegular.user),
      label: "Profile"
    ),
  ];

  bool _isShowingRecipe = false;
  bool _isRootNode = true;
  final _pageTitles = ["Home", "Recipes", "Profile"];
  bool _isLoggedIn = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width >= Breakpoint.lg) {
      return _desktopLayout();
    }

    if (width >= Breakpoint.md) {
      return _tabletLayout(height);
    }

    return _mobileLayout();
  }

  Widget _mobileLayout() {
    return Scaffold(
        appBar: _appBar(false),
        floatingActionButton: FirebaseAuth.instance.currentUser != null ? _addRecipeButton(false) : null,
        extendBodyBehindAppBar: true,
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: _targets.map((route) {
            return NavigationDestination(
              icon: route.icon,
              label: route.label,
            );
          }).toList(),
        ),
    );
  }

  Widget _tabletLayout(double height) {
    bool extendedRail = false;
    
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          groupAlignment: -1.0,
          extended: extendedRail,
          minWidth: 100,
          leading: SizedBox(height: height/2.4,),
          trailing: Expanded(
            child: Column(
              children: [
                const Spacer(flex: 2),
                if (_isLoggedIn)
                  _addRecipeButton(false),
                const SizedBox(height: 20.0)
              ],
            ),
          ),
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelType: NavigationRailLabelType.selected, //extendedRail ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
          destinations: _targets.map((route) {
            return NavigationRailDestination(
              icon: route.icon,
              label: Text(route.label),
            );
          }).toList(),
        ),
        //const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Scaffold(
            appBar: _appBar(false),
            //floatingActionButton: FirebaseAuth.instance.currentUser != null ? _addRecipeButton() : null,
            extendBodyBehindAppBar: true,
            body: _pages[_selectedIndex],
          ),
        )
      ],
    );
  }

  Widget _desktopLayout() {
    return Row(
      children: [
        NavigationDrawer(
          selectedIndex: _selectedIndex,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },//extendedRail ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Text("Scarpetta", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 20.0),
            ..._targets.map((route) {
              return NavigationDrawerDestination(
                icon: route.icon,
                label: Text(route.label),
              );
            }).toList(),
            if (_isLoggedIn)
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: MediaQuery.of(context).size.height - 430,),
                child: _addRecipeButton(true),
              ),
            const SizedBox(height: 20.0)
          ],
        ),
        //const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Scaffold(
            appBar: _appBar(true),
            //floatingActionButton: FirebaseAuth.instance.currentUser != null ? _addRecipeButton() : null,
            extendBodyBehindAppBar: true,
            body: _pages[_selectedIndex],
          ),
        )
      ],
    );
  }

  Widget _addRecipeButton(bool extended) {
    return AddRecipeButton(extended: extended);
  }

  AppBar _appBar(bool isDesktop) {
    return AppBar(
      //automaticallyImplyLeading: true,
      title: !_isShowingRecipe 
      ? Padding(
        padding: EdgeInsets.only(left: isDesktop ? 0 : 20),
        child: Text(_pageTitles[_selectedIndex]),
      )
      : null,
      centerTitle: isDesktop ? true : false,
      flexibleSpace: !_isShowingRecipe
      ? ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            width: double.infinity,
            //height: 40,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          ),
        ),
      )
      : null,
      leading: !_isRootNode 
      ? Stack(
        alignment: Alignment.center,
        children: [
          _iconBackground(),
          IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
      : null,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            _iconBackground(),
            AuthButton(),
          ],
        ),
        SizedBox(width: 5.0),
        Stack(
          alignment: Alignment.center,
          children: [
            _iconBackground(),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
              onPressed: () {
                showSearch(context: context, delegate: SCSearchDelegate());
              },
            ),
          ],
        ),
        SizedBox(width: 20.0),
      ],
    );
  }

  Widget _iconBackground() {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          width: 40,
          height: 40,
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        ),
      ),
    );
  }
}