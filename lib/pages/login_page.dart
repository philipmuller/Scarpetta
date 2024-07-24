import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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

    double size = MediaQuery.of(context).size.height * 0.4;



    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              SCImage(
                imageUrl: "https://firebasestorage.googleapis.com/v0/b/scarpetta-bb13b.appspot.com/o/ramen%20bowl.png?alt=media&token=6dfe018e-5758-42cc-970c-fa3bcda2affc",
                width: size,
                height: size,
              ),
              const SizedBox(height: 40),
              Text("Log in to get benefits!", style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  sessionState.login();
                }, 
                icon: const PhosphorIcon(PhosphorIconsRegular.signIn),
                label: const Text("Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}