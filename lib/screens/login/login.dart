import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/screens/login/local_widgets/login_form.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: '#141414'.toColor(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.asset("assets/branding-logo.png"),
                  ),
                  const LoginForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
