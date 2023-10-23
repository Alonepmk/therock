import 'dart:math';

//import 'package:flutter/material.dart';

class CalculateResult {
  int height;
  int weight;
  double result = 0;
  String msg = "Normal";

  CalculateResult(this.weight, this.height);

  String calculateResult() {
    result = weight / pow(height / 100, 2);
    return result.toStringAsFixed(1);
  }

  String getDescription() {
    if (result > 25) {
      msg = "OverWeight";
      return "This is consider as OverWeight (+_+)";
    } else if (result > 18.5) {
      msg = "Normal";
      return "This is consider as Normal (^_^)";
    } else if (result < 18.5) {
      msg = "UnderWeight";
      return "This is consider as UnderWeight (+_+)";
    }
    return "";
  }

  String getMsg() {
    if (result > 25) {
      msg = "OverWeight";
    } else if (result > 18.5) {
      msg = "Normal";
    } else if (result < 18.5) {
      msg = "UnderWeight";
    }
    return msg;
  }
}
