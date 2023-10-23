import 'package:flutter/material.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_attandance.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_profile.dart';
import 'package:therock/screens/user_screens/past_user/past_user_local_widgets/past_user_home_widget.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class PastUserHome extends StatefulWidget {
  const PastUserHome({super.key});

  @override
  State<PastUserHome> createState() => _PastUserHomeState();
}

class _PastUserHomeState extends State<PastUserHome> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      PastUserHomeWidget(),
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
