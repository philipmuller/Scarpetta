import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/providers&state/user_provider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    final session = Provider.of<SessionProvider>(context);

    return IconButton(
      icon: session.isLoggedIn 
      ? const PhosphorIcon(PhosphorIconsRegular.signOut) 
      : const PhosphorIcon(PhosphorIconsRegular.signIn),
      onPressed: () {
        if (FirebaseAuth.instance.currentUser == null) {
          session.login();
          //ref.watch(userProvider.notifier).fetchUser();
        } else {
          session.logout();
        }
        
      },
    );
  }
}