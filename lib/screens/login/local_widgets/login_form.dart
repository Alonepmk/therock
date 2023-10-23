// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/screens/root/root.dart';
import 'package:therock/screens/signup/signup.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/navigator_remove_stack.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util_login_signup.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:therock/screens/user_screens/admin/admin_home.dart';
// import 'package:therock/screens/user_screens/current_user/current_user_home.dart';
// import 'package:therock/screens/user_screens/guest/guest_home.dart';
// import 'package:therock/screens/user_screens/past_user/past_user_home.dart';
// import 'package:therock/screens/user_screens/trainer/trainer_home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  double screenWidth = 0;
  double screenHeight = 0;

  bool passwordVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Calling Login User from provider
  void _loginUser(String email, String password, BuildContext context) async {
    showLoadingDialogUtil(context);
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    ReturnDataString rds = ReturnDataString();
    try {
      rds = await currentUser.loginUserWithEmail(email, password);
      // print("yoyo ${rds.gymUser?.role}");
      if (rds.status == "success") {
        navigatorRemoveStackUtil(context, const OurRoot());
        // _doAuthRoute(
        //     context, rds.gymUser!.role!); // Route to associated Role Page
      } else {
        Navigator.pop(context);
        scaffoldUtil(context, rds.message, 3);
      }
    } catch (e) {
      Navigator.pop(context);
      scaffoldUtil(context, e.toString(), 3);
    }
  }

  // void _doAuthRoute(BuildContext context, String role) {
  //   //  print("inside role ${role}");
  //   if (role == "admin") {
  //     navigatorRemoveStackUtil(context, const AdminHome());
  //   } else if (role == "trainer") {
  //     navigatorRemoveStackUtil(context, const TrainerHome());
  //   } else if (role == "currentUser") {
  //     navigatorRemoveStackUtil(context, const CurrentUserHome());
  //   } else if (role == "pastUser") {
  //     navigatorRemoveStackUtil(context, const PastUserHome());
  //   } else {
  //     navigatorRemoveStackUtil(context, const GuestHome());
  //   }
  // }

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
              "Log In",
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: screenWidth / 35,
                  fontWeight: FontWeight.bold),
            ),
          ),
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
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () {
              _launchURL();
            },
            child: const Text(
              "By logging on, you agree to our Terms & Conditions and Privacy Statement",
              style: TextStyle(fontSize: 10),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: screenWidth / 3,
            height: screenHeight / 16,
            child: ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _loginUser(
                    emailController.text, passwordController.text, context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blueGrey.shade400),
              ),
              child: Text(
                "Log In",
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
          //       "Log In",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 20.0,
          //       ),
          //     ),
          //   ),
          //   onPressed: () {
          //     FocusManager.instance.primaryFocus?.unfocus();
          //     _loginUser(
          //         emailController.text, passwordController.text, context);
          //   },
          // ),

          TextButton(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Colors.blueGrey.shade400),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              );
            },
            child: const Text("Don't have an account? Sign up here"),
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.freeprivacypolicy.com/live/13cf789e-90e3-46e9-9065-9920cff8e9e4');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
