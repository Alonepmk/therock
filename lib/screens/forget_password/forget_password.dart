// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util_login_signup.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButton(
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  BoxContainerUtilLoginSignup(
                    child: Column(
                      children: [
                        const Text(
                          "Send Password Reset Email",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: screenWidth / 2.5,
                          height: screenHeight / 16,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (emailController.text.isEmpty) {
                                scaffoldUtil(context, "Please Fills Email", 1);
                              } else {
                                if (!emailController.text
                                    .trim()
                                    .isValidEmail()) {
                                  scaffoldUtil(
                                      context, "Email Format is not Valid", 1);
                                } else {
                                  List<GymUser> passResetUser =
                                      await GymUserDBService
                                          .readPasswordResetUserByEmail(
                                              emailController.text.trim());

                                  if (passResetUser.isNotEmpty) {
                                    sendResetEmail(emailController.text.trim());
                                  } else {
                                    scaffoldUtil(
                                        context,
                                        "Email does not Exist in the System",
                                        2);
                                  }
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blueGrey.shade400),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.email),
                                Text(
                                  "Send Email",
                                  style: TextStyle(
                                    fontSize: screenWidth / 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      scaffoldUtil(context, "Password reset Email Successfully Sent", 2);
    } on FirebaseAuthException catch (e) {
      scaffoldUtil(context, e.toString(), 2);
    }
  }
}
