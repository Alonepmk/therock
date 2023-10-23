import 'package:flutter/material.dart';
import 'package:therock/screens/user_screens/users_shared_screens/cms_container.dart';
import 'package:therock/utils/function_utils.dart';
import 'package:therock/utils/text_theme.dart';
import 'package:therock/widgets/attandance_card.dart';
import 'package:therock/widgets/trainer_manage_activities.dart';
import 'package:therock/widgets/trainer_showoff_profile_card.dart';
// import 'package:therock/states/current_user.dart';
// import 'package:provider/provider.dart';

class TrainerHomeWidget extends StatefulWidget {
  const TrainerHomeWidget({super.key});

  @override
  State<TrainerHomeWidget> createState() => _TrainerHomeWidgetState();
}

class _TrainerHomeWidgetState extends State<TrainerHomeWidget> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    //CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    // String firstName =
    //     currentUser.getCurrentUser.fullName.toString().split(" ")[0];
    return SafeArea(
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  height: 40,
                ),
              ),
              Positioned(
                left: 110,
                top: 5,
                child: Text(
                  "Welcome to The Rock!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0, // shadow blur
                        color: Colors.white.withOpacity(0.1), // shadow color
                        offset: const Offset(
                            2.0, 2.0), // how much shadow will be shown
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  color: Colors.white,
                  tooltip: 'Log Out',
                  onPressed: () {
                    showConfirmDialog(context);
                  },
                ),
              ),
              const Positioned(
                top: 5,
                left: 10,
                child: Icon(
                  Icons.diamond_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const CmsContainer(), // Top CMS container

          Column(
            children: [
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 1.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Text(
                "Functionalities",
                style: ThemeTextGym.textShadowInHomePageHeaders,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (1 / .6),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                scrollDirection: Axis.vertical,
                children: const [
                  TrainerManageActivities(),
                  TrainerShowoffProfileCard(),
                  AttandanceCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
