//this compoent was inspired by the Adaptive Scaffold from the flutter samples at https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/recipes_grid.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/pages/categories_page.dart';
import 'package:scarpetta/pages/search_page.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/util/navigator_target.dart';
import 'package:scarpetta/components/search_bar.dart';
import 'package:scarpetta/util/open_add_edit_recipe.dart';
import 'package:scarpetta/util/sc_search_delegate.dart';

class AdaptiveNavigator extends StatefulWidget {
  final List<NavigatorTarget> routes; //this assumes the app uses go_router
  final StatefulNavigationShell? navigationShell;
  final GoRouterState state;

  const AdaptiveNavigator({super.key, required this.routes, required this.state, this.navigationShell});

  @override
  State<AdaptiveNavigator> createState() => _AdaptiveNavigatorState();
}

class _AdaptiveNavigatorState extends State<AdaptiveNavigator> {
  int _selectedIndex = 0;
  bool _isShowingRecipe = false;
  bool _isRootNode = true;
  bool _canPop = false;
  bool _isShowingAllRecipes = false;
  final _pageTitles = ["Home", "Recipes", "Profile"];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    print("INIT STATE");
    _handleRouteChange();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    GoRouter.of(context).routeInformationProvider.addListener(_handleRouteChange);
    GoRouter.of(context).routerDelegate.addListener(_handleRouteChange);
    //GoRouter.of(context).routeInformationProvider.didPopRoute();

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
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            context.go(widget.routes[index].route);
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: widget.routes.map((route) {
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
                if (FirebaseAuth.instance.currentUser != null)
                  _addRecipeButton(false),
                SizedBox(height: 20.0)
              ],
            ),
          ),
          onDestinationSelected: (index) {
            context.go(widget.routes[index].route);
            setState(() {
              _selectedIndex = index;
            });
          },
          labelType: NavigationRailLabelType.selected, //extendedRail ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
          destinations: widget.routes.map((route) {
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
            body: widget.navigationShell,
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
          tilePadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          onDestinationSelected: (index) {
            context.go(widget.routes[index].route);
            setState(() {
              _selectedIndex = index;
            });
          },//extendedRail ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Text("Scarpetta", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            SizedBox(height: 20.0),
            ...widget.routes.map((route) {
              return NavigationDrawerDestination(
                icon: route.icon,
                label: Text(route.label),
              );
            }).toList(),
            if (FirebaseAuth.instance.currentUser != null)
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: MediaQuery.of(context).size.height - 430,),
                child: _addRecipeButton(true),
              ),
            SizedBox(height: 20.0)
          ],
        ),
        //const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Scaffold(
            appBar: _appBar(true),
            //floatingActionButton: FirebaseAuth.instance.currentUser != null ? _addRecipeButton() : null,
            extendBodyBehindAppBar: true,
            body: widget.navigationShell,
          ),
        )
      ],
    );
  }

  FloatingActionButton _addRecipeButton(bool extended) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < Breakpoint.md;
    if (extended) {
      return FloatingActionButton.extended(
        onPressed: () {
          openAddEditRecipe(context: context, isMobile: isMobile);
        }, 
        label: const Text('Add Recipe'),
        icon: const PhosphorIcon(PhosphorIconsRegular.plus),
      );
    }

    return FloatingActionButton(
      onPressed: () {
        openAddEditRecipe(context: context, isMobile: isMobile);
      }, 
      child: const PhosphorIcon(PhosphorIconsRegular.plus),
    );
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
              context.pop();
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
            IconButton(
              icon: FirebaseAuth.instance.currentUser == null 
              ? const PhosphorIcon(PhosphorIconsRegular.signIn) 
              : const PhosphorIcon(PhosphorIconsRegular.signOut),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  FirebaseAuth.instance.signInAnonymously();
                } else {
                  FirebaseAuth.instance.signOut();
                }
                
              },
            ),
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

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: GestureDetector(
        onTap: _handleTap,
        child: SCSearchBar(),
      ),
    );
  }

  void _handleRouteChange() {
    setState(() {
      _selectedIndex = _selectedPageIndex();

      final route = GoRouter.of(context).routeInformationProvider.value.uri.toString();

      print(route);
      print(GoRouter.of(context).canPop());
      if (GoRouter.of(context).canPop()) {
        _canPop = true;
      } else {
        _canPop = false;
      }

      if (route.contains("/recipes/") && !route.contains("/recipes/categories")) {
        _isShowingRecipe = true;
      } else {
        _isShowingRecipe = false;
      }

      if (route != "/" && route != "/recipes" && !route.contains("/recipes/categories/") && route != "/profile" && route != "" && route != "/login") {
        _isRootNode = false;
      } else {
        _isRootNode = true;
      }

      if (route == "/recipes") {
        _isShowingAllRecipes = true;
      } else {
        _isShowingAllRecipes = false;
      }

    });
  }

  int _selectedPageIndex() {
    final id = GoRouter.of(context).routeInformationProvider.value.uri.toString();

    if (id == null) {
      return 0;
    }

    if (id! == "") { //this is a terrible bugfix, I hate it, it is painful
      return 1;
    }

    if (id!.contains("home")) {
      return 0;
    }

    if (id!.contains("recipe")) {
      return 1;
    }

    if (id!.contains("profile")) {
      return 2;
    }

    if (id!.contains("login")) {
      return 2;
    }

    return 0;
  }

  _handleTap() {
    showSearch(context: context, delegate: SCSearchDelegate());
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     opaque: false,
    //     pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return Stack(
    //         children: [
    //           AnimatedBuilder(
    //             animation: animation,
    //             builder: (context, child) {
    //               return BackdropFilter(
    //                 filter: ImageFilter.blur(
    //                   sigmaX: 10.0 * animation.value, 
    //                   sigmaY: 10.0 * animation.value
    //                 ), 
    //                 child: Container(
    //                   color: Colors.transparent,
    //                 ),
    //               );
    //             },
    //           ),
    //           FadeTransition(
    //             opacity: animation, 
    //             child: child
    //           ),
    //         ],
    //       );
    //     },
    //   )
    // );
  }
}