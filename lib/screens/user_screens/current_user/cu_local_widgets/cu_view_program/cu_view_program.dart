import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/activities.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/user_screens/current_user/cu_local_widgets/cu_view_program/cu_view_activity.dart';
import 'package:therock/services/activity_db_service.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

class CuViewProgram extends StatefulWidget {
  final GymUser gymUser;
  const CuViewProgram({Key? key, required this.gymUser}) : super(key: key);

  @override
  State<CuViewProgram> createState() => _CuViewProgramState();
}

class _CuViewProgramState extends State<CuViewProgram> {
  double screenWidth = 0;
  double screenHeight = 0;

  String? currentProgramId;
  GymUser currentUser = GymUser();

  String? firstName;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _initCupstate();
    _initFirstName();
    super.initState();
  }

  Future<void> _initCupstate() async {
    await GymUserDBService.getUserInfoByIdInitState(widget.gymUser.uid).then(
      (value) {
        setState(() {
          currentUser = value;
        });
        _initProgramState();
      },
    );
  }

  void _initFirstName() {
    List<String> splitted = currentUser.fullName.toString().split(" ");
    String firstName = splitted[0];
    setState(() {
      firstName = firstName;
    });
  }

  Future<void> _initProgramState() async {
    // print("${currentUser.currentProgramIndex.toString()}      0-0-0-0-0-0-0");
    if (int.parse(currentUser.currentProgramIndex.toString()) != 0) {
      await GymUserDBService.readSpecificUserRefProgram(
              widget.gymUser.uid, currentUser.currentProgramIndex.toString())
          .then(
        (value) {
          setState(() {
            currentProgramId = value.pid;
          });
          //print("the value that is pid ${value.pid}");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

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
        child: SingleChildScrollView(
          child: (currentProgramId != null && currentProgramId != "")
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 26),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Hi ${currentUser.fullName}, here is your Day ${currentUser.currentProgramIndex} activities",
                            style: TextStyle(
                              fontSize: screenWidth / 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                        width: screenWidth,
                        height: screenWidth / 1.2,
                        child: StreamBuilder<List<Activity>>(
                            stream:
                                ActivityDBService.readByDay(currentProgramId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                    primary: false,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => CuViewActivity(
                                              activity: Activity(
                                                activityName: snapshot
                                                    .data?[index].activityName,
                                                activityDescription: snapshot
                                                    .data?[index]
                                                    .activityDescription,
                                                activityCreatedDate: snapshot
                                                    .data?[index]
                                                    .activityCreatedDate,
                                                videoLink: snapshot
                                                    .data?[index].videoLink,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          //check in container
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 8, 30, 8),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .sports_gymnastics_outlined,
                                                      size: screenWidth / 30,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${snapshot.data![index].activityName}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth / 50,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_circle_right_outlined,
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
                )
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                      screenWidth / 20, screenHeight / 3, screenWidth / 20, 0),
                  child: Column(
                    children: [
                      Text(
                        "Please Check In first to start your day 1",
                        style: TextStyle(
                          fontSize: screenWidth / 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: FloatingActionButton.extended(
                          heroTag: "view_program_open_geolocation",
                          onPressed: () {
                            CurrentUser navSelecter = Provider.of<CurrentUser>(
                                context,
                                listen: false);
                            navSelecter.setCurrentBottomNavigationBarIndex(1);
                            Navigator.pop(context);
                          },
                          label: const Text('Open GeoLocation'),
                          icon: const Icon(Icons.add_location_outlined),
                          backgroundColor: Colors.blueGrey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
