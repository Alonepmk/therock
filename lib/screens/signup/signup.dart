import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/screens/signup/local_widgets/signup_form.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: const <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButton(
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SignUpForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
