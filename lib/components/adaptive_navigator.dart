//this compoent was inspired by the Adaptive Scaffold from the flutter samples at https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart

import 'package:flutter/material.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:go_router/go_router.dart';

class AdaptiveNavigator extends StatefulWidget {
  final Widget? body;
  final List<String> routes; //this assumes the app uses go_router

  const AdaptiveNavigator({Key? key, this.body, required this.routes}) : super(key: key);

  @override
  State<AdaptiveNavigator> createState() => _AdaptiveNavigatorState();
}

class _AdaptiveNavigatorState extends State<AdaptiveNavigator> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    //if desktop
    if (width >= Breakpoint.lg) { 
      //for now, we don't care about this. I'd like to try using the NavigationRail for desktop too
    }

    //if tablet
    if (width >= Breakpoint.md) { 

    }
    
    //if mobile
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        items: widget.routes.map((route) {
          return BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: route,
          );
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: (index) {
          context.go(widget.routes[index]);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}