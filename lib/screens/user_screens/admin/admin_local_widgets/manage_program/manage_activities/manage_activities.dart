// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/activities.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_program/manage_activities/create_new_activity.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_program/manage_activities/ud_activity.dart';
import 'package:therock/services/activity_db_service.dart';

class ManageActivities extends StatefulWidget {
  final pid;
  const ManageActivities({Key? key, required this.pid}) : super(key: key);
  @override
  State<ManageActivities> createState() => _ManageActivitiesState();
}

class _ManageActivitiesState extends State<ManageActivities> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Align(
              child: Text(
                "Manage Activities",
                style: TextStyle(
                  fontSize: screenWidth / 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: StreamBuilder<List<Activity>>(
              stream: ActivityDBService.read(widget.pid),
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
                                  debugPrint('Card tapped. ${widget.pid}');
                                  Get.to(
                                    UdActivity(
                                      activity: Activity(
                                        aid: snapshot.data?[index].aid,
                                        activityName:
                                            snapshot.data?[index].activityName,
                                        activityDescription: snapshot
                                            .data?[index].activityDescription,
                                        videoLink:
                                            snapshot.data?[index].videoLink,
                                        activityCreatedDate: snapshot
                                            .data?[index].activityCreatedDate,
                                      ),
                                      pid: widget.pid,
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: screenWidth / 1.1,
                                  height: screenHeight / 5.5,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth / 3.2,
                                        height: screenHeight / 5.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            color: Colors.lightBlueAccent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                              )
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              'Activity : \n ${snapshot.data?[index].activityName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 25,
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
                                              'Description : ${snapshot.data?[index].activityDescription}',
                                              style: TextStyle(
                                                overflow: TextOverflow.fade,
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 30,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              "Link : ${snapshot.data?[index].videoLink}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 40,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Create an Activity",
        elevation: 3,
        backgroundColor: Colors.pink.withOpacity(0.4),
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          Get.to(
            () => CreateAnewActivity(
              pid: widget.pid,
            ),
          );
        },
      ),
    );
  }
}
