import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/activities.dart';
import 'package:therock/screens/user_screens/current_user/cu_local_widgets/cu_view_program/cu_view_activity.dart';
import 'package:therock/services/activity_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

class CuViewProgram extends StatefulWidget {
  const CuViewProgram({super.key});

  @override
  State<CuViewProgram> createState() => _CuViewProgramState();
}

class _CuViewProgramState extends State<CuViewProgram> {
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
        elevation: 20,
        title: Row(
          children: [
            Align(
              child: Text(
                "Programs",
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
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                width: screenWidth,
                height: screenWidth / 1.2,
                child: StreamBuilder<List<Activity>>(
                    stream: ActivityDBService.readByGymUser(
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
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(
                                    () => CuViewActivity(
                                      activity: Activity(
                                        activityName:
                                            snapshot.data?[index].activityName,
                                        activityDescription: snapshot
                                            .data?[index].activityDescription,
                                        activityCreatedDate: snapshot
                                            .data?[index].activityCreatedDate,
                                        videoLink:
                                            snapshot.data?[index].videoLink,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  //check in container
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 8, 30, 8),
                                  height: screenHeight / 14,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(2.0,
                                            2.0), // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          //color: Colors.red.shade400,
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.blueGrey.shade300,
                                              Colors.blueGrey.shade700,
                                            ],
                                          ),
                                          // borderRadius: BorderRadius.all(
                                          //   Radius.circular(20),
                                          // ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.sports_gymnastics_outlined,
                                              size: screenWidth / 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${snapshot.data![index].activityName}',
                                              style: TextStyle(
                                                fontSize: screenWidth / 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.arrow_circle_right_outlined,
                                              color: Colors.white,
                                              size: screenWidth / 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }
}
