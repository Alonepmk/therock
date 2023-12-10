import 'package:flutter/material.dart';
import 'package:therock/screens/user_screens/receptionist/receptionist_local_widget/receptionist_manage_attandance.dart';
import 'package:therock/utils/function_utils.dart';
import 'package:therock/utils/navigator_stack.dart';

class ReceptionistHome extends StatefulWidget {
  const ReceptionistHome({super.key});

  @override
  State<ReceptionistHome> createState() => _ReceptionistHomeState();
}

class _ReceptionistHomeState extends State<ReceptionistHome> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    List<Widget> listItems = const [
      ReceptionistManageAttandance(),
    ];
    List labelString = const [
      "Manage Attandance",
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
