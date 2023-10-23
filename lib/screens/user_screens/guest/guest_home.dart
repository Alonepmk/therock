import 'package:flutter/material.dart';
import 'package:therock/screens/user_screens/guest/guest_local_widgets/guest_home_widget.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_attandance.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_profile.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class GuestHome extends StatefulWidget {
  const GuestHome({super.key});

  @override
  State<GuestHome> createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      //_currentUser.getUserHomeWidget,
      GuestHomeWidget(),
      MemberAttandance(),
      MemberProfile(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 21),
      bottomNavigationBar: const BottomNavigationUtil(),
      body: pages[
          context.watch<CurrentUser>().getCurrentBottomNavigationBarIndex],
    );
  }
}
