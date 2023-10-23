// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/screens/user_screens/current_user/cu_local_widgets/cu_bmi/cu_bmi.dart';
import 'package:therock/screens/user_screens/trainer/trainer_local_widgets/manage_gymuser_activities/manage_gymuser_activities.dart';
import 'package:therock/screens/user_screens/trainer/trainer_local_widgets/trainer_showoff_profile/trainer_showoff_profile.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/text_theme.dart';
import 'package:provider/provider.dart';

class TrainerShowoffProfileCard extends StatelessWidget {
  const TrainerShowoffProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = 0;
    screenWidth = MediaQuery.of(context).size.width;

    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    return InkWell(
      onTap: () {
        Get.to(() => TrainerShowoffProfile(
              tid: currentUser.getCurrentUser.uid.toString(),
            ));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.asset(
                'assets/image-icons/membership_icon.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Showoff Profile",
                  style: ThemeTextGym.textShadowInHomePageCards,
                ),
                const SizedBox(height: 2),
                Container(
                  height: 2.5,
                  width: screenWidth / 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(-1, -1),
                          color: Colors.red.withOpacity(0.85),
                          blurRadius: 3),
                      const BoxShadow(
                          offset: Offset(1, 1),
                          color: Color.fromARGB(95, 0, 0, 0),
                          blurRadius: 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
