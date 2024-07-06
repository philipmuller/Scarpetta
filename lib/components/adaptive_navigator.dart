//this compoent was inspired by the Adaptive Scaffold from the flutter samples at https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart

import 'package:flutter/material.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:go_router/go_router.dart';
import 'package:scarpetta/util/navigation_target.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AdaptiveNavigator extends StatefulWidget {
  final Widget? body;
  final List<NavigationTarget> routes; //this assumes the app uses go_router
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
    bool extendedRail = false;
    //if desktop
    if (width >= Breakpoint.lg) { 
      //for now, we don't care about this. I'd like to try using the NavigationRail for desktop too
    }

    //if tablet
    if (width >= Breakpoint.md) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Scarpetta"),
        ),
        body: Row(
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
            labelType: extendedRail ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
            destinations: widget.routes.map((route) {
              return NavigationRailDestination(
                icon: route.icon,
                label: Text(route.label),
              );
            }).toList(),
          ),
          //const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: widget.navigationShell!,
          ),
        ],
      )
      );
    }
    
    //if mobile
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scarpetta"),
      ),
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
}