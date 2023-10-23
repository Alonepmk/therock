// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/program.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';

class AssignActivityToTrainee extends StatefulWidget {
  final GymUser gymUser;
  const AssignActivityToTrainee({Key? key, required this.gymUser})
      : super(key: key);

  @override
  State<AssignActivityToTrainee> createState() =>
      _AssignActivityToTraineeState();
}

class _AssignActivityToTraineeState extends State<AssignActivityToTrainee> {
  double screenWidth = 0;
  double screenHeight = 0;

  GymUser cupState = GymUser(); //Current selected User Program State

  List<Program> programList = [];
  List<String> programeNameList = [];

  TextEditingController _programNameController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _initCupstate();

    _initProgramListDropDown();
    super.initState();
  }

  Future<void> _initCupstate() async {
    await GymUserDBService.getUserInfoByIdInitState(widget.gymUser.uid).then(
      (value) {
        setState(() {
          cupState = value;
        });
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

    // print("the cup state");
    _programNameController.text = programList[0].programName!;
    // print("Me ssss came first ${programList[0].pid}");
  }

  @override
  Widget build(BuildContext context) {
    //CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    //print("Me dddd came first ${programList[0].pid}");
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        title: Row(
          children: [
            Align(
              child: Text(
                "Assign Activities",
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: EdgeInsets.all(screenWidth / 40),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 196, 209, 206),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 55, 98, 118),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          2.0,
                          2.0,
                        ),
                      )
                    ]),
                child: cupState.programCount != "7"
                    ? Column(
                        children: [
                          Text("Select a program : "),
                          Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FloatingActionButton.extended(
                                  heroTag: "assign_activity_reset",
                                  onPressed: () {
                                    // openAppSettings();
                                    showResetConfirmDialog(context);
                                  },
                                  label: const Text('Reset'),
                                  icon: const Icon(Icons.playlist_remove_sharp),
                                  backgroundColor: Colors.blueGrey.shade400,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: FloatingActionButton.extended(
                                  heroTag: "assign_activity_assign",
                                  onPressed: () async {
                                    showLoadingDialogUtil(context);
                                    await Future.delayed(Duration(seconds: 1));
                                    if (int.parse(
                                            cupState.programCount.toString()) <=
                                        7) {
                                      String currentProgramIndex = (int.parse(
                                                  cupState.programCount
                                                      .toString()) +
                                              1)
                                          .toString();
                                      String? pid = programList[
                                              programeNameList.indexOf(
                                                  _programNameController.text)]
                                          .pid;
                                      String? programName = programList[
                                              programeNameList.indexOf(
                                                  _programNameController.text)]
                                          .programName;
                                      GymUserDBService
                                          .addProgramReferenceToUser(
                                              pid,
                                              widget.gymUser.uid,
                                              currentProgramIndex,
                                              programName);
                                      GymUserDBService.updateUserProgramCount(
                                          widget.gymUser.uid,
                                          currentProgramIndex);
                                      _initCupstate();
                                    } else {
                                      scaffoldUtil(
                                          context,
                                          "Maximum Number of Program Count reached",
                                          2);
                                    }
                                    Navigator.pop(context);
                                  },
                                  label: const Text('Assign'),
                                  icon: const Icon(Icons.add),
                                  backgroundColor: Colors.blueGrey.shade400,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Text("Maximum Program Limit reached"),
              ),
              Container(
                padding: EdgeInsets.only(top: screenWidth / 30),
                width: double.infinity,
                height: screenHeight,
                child: StreamBuilder<List<Program>>(
                    stream:
                        GymUserDBService.readUserRefProgram(widget.gymUser.uid),
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
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(30, 8, 30, 8),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${snapshot.data![index].pid}',
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white,
                                                ),
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
                                                '${snapshot.data![index].programName}',
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        (index + 1).toString() ==
                                                cupState.programCount.toString()
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        if (cupState
                                                                .programCount ==
                                                            cupState
                                                                .currentProgramIndex) {
                                                          scaffoldUtil(
                                                              context,
                                                              "User Currently playing this Progrm, Please try again tomorrow",
                                                              2);
                                                        } else {
                                                          showLoadingDialogUtil(
                                                              context);
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 1));
                                                          String
                                                              programIndexAfterDelete =
                                                              (int.parse(cupState
                                                                          .programCount
                                                                          .toString()) -
                                                                      1)
                                                                  .toString();

                                                          GymUserDBService
                                                              .updateUserProgramCount(
                                                                  widget.gymUser
                                                                      .uid,
                                                                  programIndexAfterDelete);

                                                          GymUserDBService
                                                              .removeUserProgramRef(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .pid,
                                                                  widget.gymUser
                                                                      .uid);

                                                          _initCupstate();
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .disabled_by_default_outlined,
                                                        color: Colors.white,
                                                        size: screenWidth / 30,
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

  void showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text("!!! You sure want to Reset User Data !!!")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                showLoadingDialogUtil(context);
                GymUserDBService.removeAllUserProgramRef(widget.gymUser.uid);
                GymUserDBService.updateUserProgramCount(
                    widget.gymUser.uid, "0");
                _initCupstate();

                await Future.delayed(Duration(seconds: 1));
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
