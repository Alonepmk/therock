// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/screens/user_screens/current_user/cu_local_widgets/cu_bmr/cu_bmi.dart';
import 'package:therock/utils/text_theme.dart';

class BmiCard extends StatelessWidget {
  const BmiCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = 0;
    screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Get.to(() => const CuBmi());
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
                'assets/image-icons/bmi_icon.jpg',
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
                  "B M I",
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
