import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/screens/user_screens/current_user/cu_local_widgets/cu_home/cu_home_widget.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_attandance.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_profile.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class CurrentUserHome extends StatefulWidget {
  const CurrentUserHome({super.key});

  @override
  State<CurrentUserHome> createState() => _CurrentUserHomeState();
}

class _CurrentUserHomeState extends State<CurrentUserHome> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      //_currentUser.getUserHomeWidget,
      CurrentUserHomeWidget(),
      MemberAttandance(),
      MemberProfile(),
    ];

    return Scaffold(
      bottomNavigationBar: const BottomNavigationUtil(),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: '#141414'.toColor(),
        ),
        child: pages[
            context.watch<CurrentUser>().getCurrentBottomNavigationBarIndex],
      ),
    );
  }
}
