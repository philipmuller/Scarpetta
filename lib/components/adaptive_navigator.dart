//this compoent was inspired by the Adaptive Scaffold from the flutter samples at https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/add_recipe_button.dart';
import 'package:scarpetta/components/auth_button.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/pages/home_page.dart';
import 'package:scarpetta/pages/my_favourites_page.dart';
import 'package:scarpetta/pages/profile_page.dart';
import 'package:scarpetta/pages/recipes_page.dart';
import 'package:scarpetta/providers&state/navigation_state_provider.dart';
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

    final navState = Provider.of<NavigationState>(context);

    final List<Widget> pages = [
      Navigator(
        key: navState.navigatorKeys[0],
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => HomePage()
        )
      ),
      Navigator(
        key: navState.navigatorKeys[1],
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => RecipesPage()
        )
      ),
      Navigator(
        key: navState.navigatorKeys[2],
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => ProfilePage()
        )
      ),
    ];

    if (width >= Breakpoint.lg) {
      return _desktopLayout(navState: navState, pages: pages);
    }

    if (width >= Breakpoint.md) {
      return _tabletLayout(height, navState: navState, pages: pages);
    }

    return _mobileLayout(navState: navState, pages: pages);
  }

  Widget _mobileLayout({required NavigationState navState, required List<Widget> pages}) {
    return Scaffold(
        body: IndexedStack(
          index: navState.selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navState.selectedIndex,
          onDestinationSelected: (index) {
            navState.setIndex(index);
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

  Widget _tabletLayout(double height, {required NavigationState navState, required List<Widget> pages}) {
    bool extendedRail = false;
    
    return Row(
      children: [
        NavigationRail(
          selectedIndex: navState.selectedIndex,
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
            navState.setIndex(index);
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
          child: IndexedStack(
            index: navState.selectedIndex,
            children: pages,
          ),
        )
      ],
    );
  }

  Widget _desktopLayout({required NavigationState navState, required List<Widget> pages}) {

    return Row(
      children: [
        NavigationDrawer(
          selectedIndex: navState.selectedIndex,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          onDestinationSelected: (index) {
            navState.setIndex(index);
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
          child: IndexedStack(
            index: navState.selectedIndex,
            children: pages,
          ),
        )
      ],
    );
  }

  Widget _addRecipeButton(bool extended) {
    return AddRecipeButton(extended: extended);
  }
}