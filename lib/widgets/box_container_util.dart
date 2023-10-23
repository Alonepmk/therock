import 'package:flutter/material.dart';

class BoxContainerUtil extends StatelessWidget {
  final Widget child;
  const BoxContainerUtil({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            //offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(10.0),
      //     boxShadow: const [
      //       BoxShadow(
      //         color: Colors.grey,
      //         blurRadius: 10.0,
      //         spreadRadius: 1.0,
      //         offset: Offset(
      //           4.0,
      //           4.0,
      //         ),
      //       )
      //     ]),
      child: child,
    );
  }
}
