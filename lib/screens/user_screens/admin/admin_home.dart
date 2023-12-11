import 'package:flutter/material.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/cms/manage_cms.dart';
//import 'package:therock/screens/user_screens/admin/admin_local_widgets/export_excel/manage_export_excel.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/feed_back/manage_feed_back.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_gym_user/manage_gym_user_home.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_membership/manage_membership.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_program/manage_program.dart';
import 'package:therock/utils/function_utils.dart';
import 'package:therock/utils/navigator_stack.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    List<Widget> listItems = const [
      ManageGymUser(),
      ManageProgram(),
      ManageMembership(),
      ManageCms(),
      ManageFeedBack(),
      //ManageExportExcel(),
    ];
    List labelString = const [
      "Manage Gym User",
      "Manage Program",
      "Manage Membership",
      "Manage Cms",
      "Manage FeedBack",
      //"Manage Export Excel"
    ];
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
          child: Column(
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
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
                            color:
                                Colors.white.withOpacity(0.1), // shadow color
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
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(40),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: listItems
                      .map((item) => Card(
                            //color: Colors.transparent,
                            color: Colors.blue.withOpacity(0.8),
                            elevation: 6,
                            child: InkWell(
                              onTap: () => navigatorStackUtil(context, item),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "${labelString[listItems.indexOf(item)]}",
                                    style: TextStyle(
                                      fontSize: screenWidth / 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
