// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/activities.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/program.dart';
import 'package:therock/services/activity_db_service.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util2.dart';
import 'package:provider/provider.dart';

class AssignActivityToTrainee extends StatefulWidget {
  final GymUser gymUser;
  const AssignActivityToTrainee({Key? key, required this.gymUser})
      : super(key: key);

  @override
  State<AssignActivityToTrainee> createState() =>
      _AssignActivityToTraineeState();
}

class _AssignActivityToTraineeState extends State<AssignActivityToTrainee> {
  List<Program> programList = [];
  List<String> programeNameList = [];
  List<Activity> activityList = [];

  double screenWidth = 0;
  double screenHeight = 0;

  GymUser cupState = GymUser(); //Current selected User Program State

  TextEditingController _programNameController = TextEditingController();
  @override
  void initState() {
    _initCupstate();
    _initActivityList();
    super.initState();
  }

  Future<void> _initCupstate() async {
    await GymUserDBService.getUserInfoByIdInitState(widget.gymUser.uid).then(
      (value) {
        setState(() {
          cupState = value;
        });
        _initProgramListDropDown();
      },
    );
  }

  Future<void> _initProgramListDropDown() async {
    await FirebaseFirestore.instance
        .collection("programs")
        .orderBy("programName")
        .get()
        .then(
      (querySnapshot) {
        debugPrint("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          var snapshot = docSnapshot.data();

          Program program = Program(
            pid: docSnapshot.id,
            programName: snapshot['programName'],
            programDescription: snapshot['programDescription'],
            programCreatedDate: snapshot['programCreatedDate'],
          );
          setState(() {
            programList.add(program);
            programeNameList.add(program.programName ?? '');
          });
          debugPrint('${docSnapshot.id} => ${snapshot["programName"]}');
          //print(trainerList[0].email);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );

    _programNameController.text =
        (cupState.programName ?? programList[0].programName)!;
  }

  Future<void> _initActivityList() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.gymUser.uid)
        .collection("activities")
        .get()
        .then(
      (querySnapshot) {
        debugPrint("Successfully loaded Activities");
        for (var docSnapshot in querySnapshot.docs) {
          var snapshot = docSnapshot.data();

          Activity activity = Activity(
            aid: docSnapshot.id,
            activityName: snapshot['activityName'],
            activityDescription: snapshot['activityDescription'],
            videoLink: snapshot['videoLink'],
            flag: snapshot['flag'],
            activityCreatedDate: snapshot['activityCreatedDate'],
          );
          setState(() {
            activityList.add(activity);
          });

          //print(trainerList[0].email);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );

    //print("Me ssss came first ${programList[0].pid}");
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    //print("Me dddd came first ${programList[0].pid}");
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 21),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                BoxContainerUtil2(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        cupState.programName == null
                            ? Row(
                                children: [
                                  Text("Select a Program : "),
                                  Container(
                                    margin: const EdgeInsets.only(top: 15.0),
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: DropdownButton(
                                      dropdownColor: Colors.lightBlue,
                                      hint: const Text(
                                          'Select Program'), // Not necessary for Option 1
                                      value: _programNameController.text,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _programNameController =
                                              TextEditingController(
                                                  text: newValue.toString());
                                        });
                                      },
                                      items: programeNameList.map((name) {
                                        return DropdownMenuItem(
                                          value: name,
                                          child: Text(name),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "${widget.gymUser.fullName} is in the ${cupState.programName}\nClick remove to change program"),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            cupState.programName != null
                                ? InkWell(
                                    onTap: () async {
                                      showLoadingDialogUtil(context);
                                      // Navigator.pop(context);
                                      debugPrint(
                                          "The cup user object ${cupState.programName} : uid : ${currentUser.getCurrentUser.uid} : trainerUID : ${cupState.trainnerUid}");
                                      await GymUserDBService
                                          .removeAllActivitiesFromUser(
                                              widget.gymUser.uid);
                                      setState(() {
                                        cupState.programName = null;
                                        cupState.pid = null;
                                        activityList = [];
                                      });
                                      await GymUserDBService.assignTrainne(
                                          cupState, cupState.trainnerUid);
                                      await GymUserDBService.updateUserInfo(
                                          cupState);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "remove",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      //Navigator.pop(context);
                                      showLoadingDialogUtil(context);
                                      debugPrint(
                                          "The cup user object ${cupState.programName} : uid : ${currentUser.getCurrentUser.uid} : trainerUID : ${cupState.trainnerUid}");

                                      setState(() {
                                        cupState.programName =
                                            _programNameController.text;
                                        cupState.pid = programList[
                                                programeNameList.indexOf(
                                                    _programNameController
                                                        .text)]
                                            .pid;
                                      });
                                      await GymUserDBService
                                          .addAllActivitiesToUser(
                                              cupState.pid, widget.gymUser.uid);
                                      await _initActivityList();
                                      await GymUserDBService.assignTrainne(
                                          cupState, cupState.trainnerUid);
                                      await GymUserDBService.updateUserInfo(
                                          cupState);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Assign",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                programList.isNotEmpty &&
                        cupState.programName != null &&
                        activityList.isNotEmpty
                    ? BoxContainerUtil2(
                        child: Column(
                          children: [
                            Center(
                              child: Text("User Activities"),
                            ),
                            const Divider(),
                            SizedBox(
                              height: screenHeight / 1.5,
                              child: StreamBuilder<List<Activity>>(
                                  stream: ActivityDBService.read(programList[
                                          programeNameList.indexOf(
                                              _programNameController.text)]
                                      .pid),
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
                                      // for (var i = 0;
                                      //     i < snapshot.data!.length;
                                      //     i++) {
                                      //   print(
                                      //       " hello hello ${snapshot.data![i].activityName} , ${activityList[i].activityName}");
                                      // }

                                      if (snapshot.data!.length ==
                                          activityList.length) {
                                        return ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ListTile(
                                                leading: const Icon(Icons.list),
                                                trailing: activityList[index]
                                                            .flag ==
                                                        false
                                                    ? Icon(Icons
                                                        .check_circle_outline)
                                                    : Icon(Icons.check_circle),
                                                onTap: () {
                                                  setState(() {
                                                    activityList[index].flag =
                                                        !activityList[index]
                                                            .flag!;
                                                  });
                                                },
                                                title: Text(
                                                    "${snapshot.data![index].activityName}"),
                                                subtitle: Text(
                                                    "${snapshot.data![index].activityDescription}"),
                                              );
                                            });
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                            ),
                            const Divider(),
                            InkWell(
                              onTap: () {
                                //Navigator.pop(context);
                                showLoadingDialogUtil(context);
                                // ignore: avoid_function_literals_in_foreach_calls
                                activityList.forEach((element) async {
                                  debugPrint(
                                      "the data ${element.activityName} is selected----+++");
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.gymUser.uid)
                                      .collection("activities")
                                      .doc(element.aid)
                                      .set({
                                    "flag": element.flag,
                                  }, SetOptions(merge: true));
                                });
                                Navigator.pop(context);
                                scaffoldUtil(
                                    context, "successfully updated", 1);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                margin: EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Update",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
