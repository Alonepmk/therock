import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

class BottomNavigationUtil extends StatefulWidget {
  const BottomNavigationUtil({super.key});

  @override
  State<BottomNavigationUtil> createState() => _BottomNavigationUtilState();
}

class _BottomNavigationUtilState extends State<BottomNavigationUtil> {
  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    return CurvedNavigationBar(
      height: 50,
      items: const [
        CurvedNavigationBarItem(
          child: Icon(Icons.home_outlined, color: Colors.white),
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.location_on_outlined, color: Colors.white),
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.person_2_outlined, color: Colors.white),
        ),
      ],
      //color: Color.fromARGB(255, 253, 235, 235),
      color: Colors.grey.withOpacity(0.1),
      buttonBackgroundColor: Colors.grey.withOpacity(0.3),
      //buttonBackgroundColor: '#f5f5dc'.toColor(),
      backgroundColor: '#141414'.toColor(),
      animationCurve: Curves.fastEaseInToSlowEaseOut,
      animationDuration: const Duration(milliseconds: 300),
      iconPadding: 4,
      onTap: (index) {
        //print("hello ${index}");
        currentUser.setCurrentBottomNavigationBarIndex(index);
        //print(currentUser.getCurrentBottomNavigationBarIndex);
      },
    );
  }
}

// color: Color.fromARGB(255, 207, 221, 10),
//       buttonBackgroundColor: Color.fromARGB(255, 255, 221, 0),
//       backgroundColor: Color.fromARGB(255, 95, 95, 95),
