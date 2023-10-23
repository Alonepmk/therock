import 'package:flutter/material.dart';

navigatorStackUtil(BuildContext context, Widget route) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}
