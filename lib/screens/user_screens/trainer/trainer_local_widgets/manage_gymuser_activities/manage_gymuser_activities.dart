import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/user_screens/trainer/trainer_local_widgets/manage_gymuser_activities/assign_activity.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

class ManageGymuserActivitiesWidget extends StatefulWidget {
  const ManageGymuserActivitiesWidget({super.key});

  @override
  State<ManageGymuserActivitiesWidget> createState() =>
      _ManageGymuserActivitiesWidgetState();
}

class _ManageGymuserActivitiesWidgetState
    extends State<ManageGymuserActivitiesWidget> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        title: Row(
          children: [
            Align(
              child: Text(
                "Manage Activities",
                style: TextStyle(
                  fontSize: screenWidth / 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: StreamBuilder<List<GymUser>>(
              stream: GymUserDBService.readTrainerTrainne(
                  currentUser.getCurrentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Some error occured"),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: Card(
                              // clipBehavior is necessary because, without it, the InkWell's animation
                              // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                              // This comes with a small performance cost, and you should not set [clipBehavior]
                              // unless you need it.
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onLongPress: () {
                                  debugPrint('Card tapped. $snapshot');
                                  Get.to(
                                    () => AssignActivityToTrainee(
                                      gymUser: GymUser(
                                        uid: snapshot.data?[index].uid,
                                        email: snapshot.data?[index].email,
                                        phoneNumber:
                                            snapshot.data?[index].phoneNumber,
                                        fullName:
                                            snapshot.data?[index].fullName,
                                        programCount:
                                            snapshot.data?[index].programCount,
                                        currentProgramIndex: snapshot
                                            .data?[index].currentProgramIndex,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: screenWidth / 2.2,
                                  height: screenHeight / 6,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth / 7.0,
                                        height: screenHeight / 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Colors.blueGrey.shade700,
                                                Colors.blueGrey.shade300,
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade400,
                                                blurRadius: 4.0,
                                                spreadRadius:
                                                    4.0, // shadow direction: bottom left
                                              )
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Trainne : \n ${snapshot.data?[index].fullName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              'email : ${snapshot.data?[index].email}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 55,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              "Phone: ${snapshot.data?[index].phoneNumber}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 55,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
