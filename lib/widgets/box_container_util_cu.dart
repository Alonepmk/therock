import 'package:flutter/material.dart';

class BoxContainerUtilCu extends StatelessWidget {
  final Widget child;
  const BoxContainerUtilCu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        //color: Color.fromARGB(255, 1, 199, 156),
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            //color: Color.fromARGB(255, 47, 248, 84),
            blurRadius: 5.0,
            spreadRadius: 1.0,

            color: Colors.white,
          ),
        ],
      ),
      child: child,
    );
  }
}
