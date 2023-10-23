import 'package:flutter/material.dart';

navigatorRemoveStackUtil(BuildContext context, Widget route) {
  return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
      (route) => false);
}
