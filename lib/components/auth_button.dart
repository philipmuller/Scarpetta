import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/providers&state/session_provider.dart';

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
      onPressed: () async {
        if (FirebaseAuth.instance.currentUser == null) {
          try {
            await session.login();
          } catch (e) {
            print("Error logging in: $e");
          }
          
        } else {
          session.logout();
        }
        
      },
    );
  }
}