import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_attandance.dart';
import 'package:therock/screens/user_screens/member_shared_screens/member_profile.dart';
import 'package:therock/screens/user_screens/trainer/trainer_local_widgets/trainer_home_widget.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class TrainerHome extends StatefulWidget {
  const TrainerHome({super.key});

  @override
  State<TrainerHome> createState() => _TrainerHomeState();
}

class _TrainerHomeState extends State<TrainerHome> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      //_currentUser.getUserHomeWidget,
      TrainerHomeWidget(),
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
