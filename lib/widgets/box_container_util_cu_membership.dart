import 'package:flutter/material.dart';

class BoxContainerUtilCuMembership extends StatelessWidget {
  final Widget child;
  const BoxContainerUtilCuMembership({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        //color: Color.fromARGB(255, 1, 199, 156),
        //color: Colors.grey.withOpacity(0.3),
        color: Colors.white12.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            //color: Color.fromARGB(255, 47, 248, 84),
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(
              2.0,
              2.0,
            ),
          )
        ],
      ),
      child: child,
    );
  }
}
