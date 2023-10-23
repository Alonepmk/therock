import 'package:flutter/material.dart';

showLoadingDialogUtil(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blueGrey,
          color: Colors.white,
          strokeCap: StrokeCap.round,
        ),
      );
    },
  );
}
