import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/providers&state/user_provider.dart';

class AuthButton extends ConsumerWidget {
  const AuthButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: FirebaseAuth.instance.currentUser == null 
      ? const PhosphorIcon(PhosphorIconsRegular.signIn) 
      : const PhosphorIcon(PhosphorIconsRegular.signOut),
      onPressed: () {
        if (FirebaseAuth.instance.currentUser == null) {
          FirebaseAuth.instance.signInAnonymously();
          ref.watch(userProvider.notifier).fetchUser();
        } else {
          FirebaseAuth.instance.signOut();
        }
        
      },
    );
  }
}