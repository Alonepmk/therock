// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/login/login.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    //GymUser user = currentUser.getCurrentUser;
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        title: Row(
          children: [
            Align(
              child: Text(
                "Account Setting",
                style: TextStyle(
                  fontSize: screenWidth / 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24.0),
              const Text(
                'Account Deletion',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Change to your app's theme color
                ),
              ),
              const Text(
                'Deleting your account will permanently remove all your data and cannot be undone. Please consider the consequences before proceeding.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red, // Change to your app's text color
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  TextEditingController emailController =
                      TextEditingController();
                  TextEditingController passwordController =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                decoration:
                                    const InputDecoration(hintText: "Email"),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: passwordController,
                                decoration:
                                    const InputDecoration(hintText: "Password"),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('cancle'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('Proceed'),
                            onPressed: () {
                              CurrentUser cu = Provider.of<CurrentUser>(context,
                                  listen: false);
                              if (emailController.text ==
                                  cu.getCurrentUser.email) {
                                if (passwordController.text.isNotEmpty &&
                                    passwordController.text.length >= 6) {
                                  GymUser currentSession = cu.getCurrentUser;
                                  deleteuserAccount(
                                      emailController.text,
                                      passwordController.text,
                                      currentSession,
                                      context);
                                } else {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  scaffoldUtil(
                                      context,
                                      "Please enter correct Password to DELETE your ACCOUNT!!!",
                                      2);
                                }
                              } else {
                                FocusManager.instance.primaryFocus?.unfocus();
                                scaffoldUtil(
                                    context,
                                    "Please enter correct Email to DELETE your ACCOUNT!!!",
                                    2);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade400),
                ),
                child: Text(
                  "!!! Click Here to Delete Your Account !!!",
                  style: TextStyle(
                    fontSize: screenWidth / 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteuserAccount(String email, String pass, GymUser currentSession,
      BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = await _auth.currentUser;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: pass);

    print(email);

    if (user != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        showLoadingDialogUtil(context);
        await user.reauthenticateWithCredential(credential).then((value) {
          if (currentSession.trainnerUid != null &&
              currentSession.trainnerUid != "") {
            GymUserDBService.removeTrainne(
                currentSession.uid, currentSession.trainnerUid);
            GymUserDBService.removeTrainner(currentSession.uid);
          }
          GymUserDBService.emptyAccountData(currentSession.uid);
          value.user!.delete().then((res) {
            Navigator.pop(context);
            Get.offAll(() => const Login());
            scaffoldUtil(context, "Account Successfully deleted", 1);
          });
        });
      } catch (e) {
        Navigator.pop(context);
        scaffoldUtil(context, e.toString(), 1);
      }
    } else {
      scaffoldUtil(context, "Password is incorrect", 1);
    }
  }
}
