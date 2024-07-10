//this compoent was inspired by the Adaptive Scaffold from the flutter samples at https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart

import 'package:flutter/material.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/util/navigator_target.dart';
import 'package:scarpetta/components/sc_app_bar.dart';

class AdaptiveNavigator extends StatefulWidget {
  final Widget? body;
  final List<NavigatorTarget> routes; //this assumes the app uses go_router
  final StatefulNavigationShell? navigationShell;

  const AdaptiveNavigator({super.key, this.body, required this.routes, this.navigationShell});

  @override
  State<AdaptiveNavigator> createState() => _AdaptiveNavigatorState();
}

class _AdaptiveNavigatorState extends State<AdaptiveNavigator> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= Breakpoint.lg) {
      //implement desktop layout
    }

    if (width >= Breakpoint.md) {
      return _tabletLayout();
    }

    return _mobileLayout();
  }

  Widget _mobileLayout() {
    return Scaffold(
        appBar: _appBar(),
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

  Widget _tabletLayout() {
    bool extendedRail = false;
    
    return Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: 0.0,
            extended: extendedRail,
            minWidth: 100,
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
              appBar: _appBar(),
              extendBodyBehindAppBar: true,
              body: widget.navigationShell,
            ),
          )
        ],
      );
  }

  SCAppBar _appBar() {
    return SCAppBar(title: widget.routes[_selectedIndex].label);
  }
}