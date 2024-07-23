import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/sc_image.dart';
import 'package:scarpetta/providers&state/session_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';

class LoginPage extends StatelessWidget {
  final double topPadding = 65.0;
  final double xPadding = 30.0;

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context){//, WidgetRef ref) {
    final sessionState = Provider.of<SessionProvider>(context);

    double width = MediaQuery.of(context).size.width;
    bool mobileModal = true;
    bool isDesktop = false;

    double cardWidth = 260;
    double cardHeight = 300;

    double size = 400;

    if (width > Breakpoint.md) {
      mobileModal = false;
    }
    if (width > Breakpoint.lg) {
      isDesktop = true;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SCImage(
              imageUrl: "https://firebasestorage.googleapis.com/v0/b/scarpetta-bb13b.appspot.com/o/ramen%20bowl.png?alt=media&token=6dfe018e-5758-42cc-970c-fa3bcda2affc",
              width: size,
              height: size,
            ),
            SizedBox(height: 100),
            Text("Log in to get benefits!", style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                sessionState.login();
              }, 
              child: Text("Log in")
            ),
          ],
        ),
      ),
    );
  }
}