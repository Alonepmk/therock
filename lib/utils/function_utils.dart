// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/screens/login/login.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

void showConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Confirm'),
        content: const SingleChildScrollView(
          child: Row(
            children: [
              Expanded(child: Text("!You sure want to logout?")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => _signOut(context),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

Future<void> _signOut(BuildContext context) async {
  CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
  String returnString = await currentUser.signOut();
  if (returnString == "success") {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false);
  }
}
