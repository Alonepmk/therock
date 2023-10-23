import 'package:flutter/material.dart';

class BoxContainerUtil2 extends StatelessWidget {
  final Widget child;
  const BoxContainerUtil2({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 196, 209, 206),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 55, 98, 118),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(
                2.0,
                2.0,
              ),
            )
          ]),
      child: child,
    );
  }
}
