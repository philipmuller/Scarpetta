import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/auth_button.dart';
import 'package:scarpetta/providers&state/navigation_state_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/sc_search_delegate.dart';

class SCAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool transparent;

  const SCAppBar({super.key, this.title, this.transparent = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isDesktop = false;
    if (width > Breakpoint.lg) {
      isDesktop = true;
    }
    return _appBar(isDesktop, context);
  }

  AppBar _appBar(bool isDesktop, BuildContext context) {
    final navState = Provider.of<NavigationState>(context);
    
    return AppBar(
      automaticallyImplyLeading: true,
      title: (title != null) 
      ? Padding(
        padding: EdgeInsets.only(left: isDesktop ? 0 : 20),
        child: Text(title!),
      )
      : null,
      centerTitle: isDesktop ? true : false,
      flexibleSpace: !transparent
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
      // leading: !_isRootNode 
      // ? Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     _iconBackground(),
      //     IconButton(
      //       icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // )
      // : null,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            _iconBackground(context),
            AuthButton(),
          ],
        ),
        SizedBox(width: 5.0),
        Stack(
          alignment: Alignment.center,
          children: [
            _iconBackground(context),
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

  Widget _iconBackground(BuildContext context) {
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