// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util_login_signup.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  double screenWidth = 0;
  double screenHeight = 0;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  void _signUpUser(String email, String password, BuildContext context,
      String fullName) async {
    showLoadingDialogUtil(context);

    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      rds = await currentUser.signUpUser(
          email, password, fullName); //call provider to sign up the user

      if (rds.status == "success") {
        Navigator.pop(context);
        scaffoldUtil(context, rds.message!, 3);
        Navigator.pop(context);
      } else {
        scaffoldUtil(context, rds.message!, 3);
        Navigator.pop(context);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.height;
    }

    return BoxContainerUtilLoginSignup(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Sign Up",
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            controller: fullNameController,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Colors.white70,
              ),
              hintText: "Full Name",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white70,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white60,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: emailController,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.alternate_email,
                color: Colors.white70,
              ),
              hintText: "Email",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white70,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white60,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: passwordController,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.white70,
              ),
              hintText: "Password",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white70,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white60,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
            obscureText: !passwordVisible,
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: confirmPasswordController,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_open,
                color: Colors.white70,
              ),
              hintText: "Confirm Password",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white70,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white60,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    confirmPasswordVisible = !confirmPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !confirmPasswordVisible,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: screenWidth / 3,
            height: screenHeight / 16,
            child: ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (passwordController.text == confirmPasswordController.text) {
                  _signUpUser(emailController.text, passwordController.text,
                      context, fullNameController.text);
                } else {
                  scaffoldUtil(context, "Password Do Not Match", 3);
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blueGrey.shade400),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: screenWidth / 45,
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 100),
          //     child: Text(
          //       "Sign Up",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 20.0,
          //       ),
          //     ),
          //   ),
          //   onPressed: () {
          //     FocusManager.instance.primaryFocus?.unfocus();
          //     if (passwordController.text == confirmPasswordController.text) {
          //       _signUpUser(emailController.text, passwordController.text,
          //           context, fullNameController.text);
          //     } else {
          //       scaffoldUtil(context, "Password Do Not Match", 3);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
