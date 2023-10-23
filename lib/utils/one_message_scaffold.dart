import 'package:flutter/material.dart';

scaffoldUtil(BuildContext context, String? rdsMessage, int duration) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150,
        left: 10,
        right: 10,
      ),
      content: Text(" $rdsMessage "),
      duration: Duration(seconds: duration),
    ),
  );
}
