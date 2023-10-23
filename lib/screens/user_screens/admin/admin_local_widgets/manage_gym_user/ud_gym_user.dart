// ignore_for_file: unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/gym_user_roles.dart';
import 'package:therock/models/membership.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';
import 'package:intl/intl.dart';

class AdminCrudGymUser extends StatefulWidget {
  final GymUser gymUser;
  const AdminCrudGymUser({Key? key, required this.gymUser}) : super(key: key);

  @override
  State<AdminCrudGymUser> createState() => _AdminCrudGymUserState();
}

class _AdminCrudGymUserState extends State<AdminCrudGymUser> {
  double screenWidth = 0;
  double screenHeight = 0;
  List<GymUser> trainerList = [];
  List<String> trainerName = [];
  String? currentTrainerName;
  String? currentTrainerUid;

  List<Membership> membershipList = [];
  List<String> membershipType = [];

  String startDate = "Start Date";
  String endDate = "End Date";
  String? stateMembershipName;

  TextEditingController? _fullNameController,
      _emailController,
      _roleController,
      _isLoginController,
      _accountCreatedController;
  TextEditingController _trainerController = TextEditingController();
  TextEditingController _membershipController = TextEditingController();

  final List<String> _roleDropDown = [
    describeEnum(GymUserRole.currentUser),
    describeEnum(GymUserRole.pastUser),
    describeEnum(GymUserRole.trainer),
    describeEnum(GymUserRole.guest),
  ];

  @override
  void initState() {
    super.initState();
    _initiateTrainerList();
    _initiateMembershipList();
    //print("hello current membership ${widget.gymUser.currentMembershipName}");
    _fullNameController = TextEditingController(text: widget.gymUser.fullName);
    _emailController = TextEditingController(text: widget.gymUser.email);
    _roleController = TextEditingController(text: widget.gymUser.role);
    _isLoginController = TextEditingController(text: widget.gymUser.role);

    currentTrainerName = widget.gymUser.trainnerName;
    currentTrainerUid = widget.gymUser.trainnerUid;
    stateMembershipName = widget.gymUser.currentMembershipName;
  }

  void _initiateTrainerList() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "trainer")
        .get()
        .then(
      (querySnapshot) {
        debugPrint("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          var snapshot = docSnapshot.data();
          GymUser trainer = GymUser(
            uid: docSnapshot.id,
            email: snapshot['email'],
            fullName: snapshot['fullName'],
            address: snapshot['address'],
            phoneNumber: snapshot['phoneNumber'],
            profilePicLink: snapshot['profilePicLink'],
            dob: snapshot['dob'],
            role: snapshot['role'],
            isLogin: snapshot['isLogin'],
            accountCreated: snapshot['accountCreated'],
          );
          setState(() {
            trainerList.add(trainer);
            trainerName.add(trainer.fullName ?? '');
          });
          //print('${docSnapshot.id} => ${snapshot["role"]}');
          //print(trainerList[0].email);
        }
      },
      // ignore: avoid_print
      onError: (e) => print("Error completing: $e"),
    );

    if ((widget.gymUser.trainnerName != "") &&
        (widget.gymUser.trainnerName != null)) {
      _trainerController =
          TextEditingController(text: widget.gymUser.trainnerName);
    } else {
      // print("testing 1 ${widget.gymUser.role}");
      // if (widget.gymUser.role != "trainer") {
      //   print("testing 1 ${widget.gymUser.role}");
      //   _trainerController = TextEditingController(text: trainerName[0]);
      // } else {
      //   print("testing 2 ${widget.gymUser.role}");
      //   _trainerController = TextEditingController(text: "invalid");
      // }
      _trainerController = TextEditingController(text: trainerName[0]);
    }
  }

  void _initiateMembershipList() async {
    await FirebaseFirestore.instance.collection("membership").get().then(
      (querySnapshot) {
        debugPrint("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          var snapshot = docSnapshot.data();
          Membership membership = Membership(
              mid: docSnapshot.id,
              membershipType: snapshot['membershipType'],
              membershipDescription: snapshot['membershipDescription'],
              membershipCreatedDate: snapshot['membershipCreatedDate']);
          setState(() {
            membershipList.add(membership);
            membershipType.add(membership.membershipType ?? '');
          });
          //print('${docSnapshot.id} => ${snapshot["role"]}');
          //print(trainerList[0].email);
        }
      },
      // ignore: avoid_print
      onError: (e) => print("Error completing: $e"),
    );

    if ((widget.gymUser.currentMembershipName != "") &&
        (widget.gymUser.currentMembershipName != null)) {
      _membershipController =
          TextEditingController(text: widget.gymUser.currentMembershipName);
      setState(() {
        startDate = widget.gymUser.membershipStartDate ?? "Start Date";
        endDate = widget.gymUser.membershipEndDate ?? "End Date";
        //print("iw sassdfas here here here gggg ${widget.gymUser.membershipStartDate}");
      });
    } else {
      _membershipController = TextEditingController(text: membershipType[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Manage Gym Users ${widget.gymUser.role} "),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  BoxContainerUtil(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "User Name",
                            hintText: "User Name",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            hintText: "Email",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              //margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton(
                                dropdownColor: Colors.lightBlue,
                                hint: const Text(
                                    'Select Role'), // Not necessary for Option 1
                                value: _roleController!.text,
                                onChanged: (newValue) {
                                  setState(() {
                                    _roleController = TextEditingController(
                                        text: newValue.toString());
                                  });
                                },
                                items: _roleDropDown.map((role) {
                                  return DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                userDeleteConfirmDialog(context);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "delete",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                GymUser tempUser = widget.gymUser;
                                tempUser.role =
                                    _roleController!.text.toString();
                                tempUser.fullName =
                                    _fullNameController!.text.toString();
                                userUpdateConfirmDialog(context, tempUser);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
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
                      ],
                    ),
                  ),
                  widget.gymUser.role != "trainer"
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: BoxContainerUtil(
                            child: SizedBox(
                              width: screenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  currentTrainerName == ""
                                      ? Text("Assign a Trainer")
                                      : Text("Update Trainer"),
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
                                          'Select Trainer'), // Not necessary for Option 1
                                      value: _trainerController.text,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _trainerController =
                                              TextEditingController(
                                                  text: newValue.toString());
                                        });
                                      },
                                      items: trainerName.map((name) {
                                        return DropdownMenuItem(
                                          value: name,
                                          child: Text(name),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          removeTrainerFromUserConfirmDialog(
                                              context);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                "Remove",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          assignTrainerConfirmDialog(context);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.green,
                                          ),
                                          child: Row(
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
                                              currentTrainerName == ""
                                                  ? Text(
                                                      "Assign",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      "Current Trainner : ${currentTrainerName ?? ""}"),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  widget.gymUser.role != "trainer" && membershipType.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: BoxContainerUtil(
                            child: Column(
                              children: [
                                stateMembershipName == "" ||
                                        stateMembershipName == null
                                    ? Text("Assign Membership")
                                    : Text("Remove or Update Membership"),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: DropdownButton(
                                    dropdownColor: Colors.lightBlue,
                                    hint: const Text(
                                        'Select Membership'), // Not necessary for Option 1
                                    value: _membershipController.text,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _membershipController =
                                            TextEditingController(
                                                text: newValue.toString());
                                      });
                                    },
                                    items: membershipType.map((name) {
                                      return DropdownMenuItem(
                                        value: name,
                                        child: Text(name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(3000),
                                          builder: (context, child) {
                                            return Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: SizedBox(
                                                      height: 500,
                                                      width: 900,
                                                      child: child,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              startDate =
                                                  DateFormat("MM/dd/yyyy")
                                                      .format(value);
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: kToolbarHeight,
                                        width: screenWidth * 0.21,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding:
                                            const EdgeInsets.only(left: 11),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                137, 39, 37, 37),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            startDate,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromARGB(77, 0, 0, 0),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(3000),
                                          builder: (context, child) {
                                            return Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: SizedBox(
                                                      height: 500,
                                                      width: 900,
                                                      child: child,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              endDate = DateFormat("MM/dd/yyyy")
                                                  .format(value);
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: kToolbarHeight,
                                        width: screenWidth * 0.21,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding:
                                            const EdgeInsets.only(left: 11),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                137, 39, 37, 37),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            endDate,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromARGB(77, 0, 0, 0),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                stateMembershipName == "" ||
                                        stateMembershipName == null
                                    ? InkWell(
                                        onTap: () {
                                          assingMembershipConfirmDialog(
                                              context);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      )
                                    : Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              removeMembershipConfirmDialog(
                                                  context);
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                                    "Remove",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  updateMembershipConfirmDialog(
                                                      context);
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.green,
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.update,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "update",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  historyMembershipConfirmDialog(
                                                      context);
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.green,
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "History",
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "Current Membership : ${stateMembershipName ?? ""}"),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void userUpdateConfirmDialog(BuildContext context, GymUser tempUser) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(child: Text("!You sure want to Update?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));
                GymUserDBService.updateUser(tempUser);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void userDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "!You sure want to Delete this User, Action Cannot be Undo?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));
                if (widget.gymUser.role == "trainer") {
                  GymUserDBService.removeTrainner(widget.gymUser.uid);
                  GymUserDBService.deleteUser(widget.gymUser.uid);
                } else {
                  if (currentTrainerName != "" && currentTrainerName != null) {
                    var currentIndexofTrainerName =
                        trainerName.indexOf(_trainerController.text);

                    GymUserDBService.removeTrainne(widget.gymUser.uid,
                        trainerList[currentIndexofTrainerName].uid);
                  }
                  GymUserDBService.removeAllAttandanceRecord(
                      widget.gymUser.uid);
                  GymUserDBService.removeAllMembershipHistoryRecord(
                      widget.gymUser.uid);
                  GymUserDBService.removeAllUserProgramRef(widget.gymUser.uid);
                  GymUserDBService.deleteUser(widget.gymUser.uid);
                }

                scaffoldUtil(context, "User Successfully Deleted", 3);
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

  void assignTrainerConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child:
                        Text("!You sure want to Assign this Trainer to User?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));

                var currentIndexofTrainerName =
                    trainerName.indexOf(_trainerController.text);

                GymUserDBService.assignTrainer(
                    trainerList[currentIndexofTrainerName].uid,
                    widget.gymUser.uid,
                    _trainerController.text);

                GymUserDBService.assignTrainne(
                    widget.gymUser, trainerList[currentIndexofTrainerName].uid);

                if ((currentTrainerUid != "") &&
                    (currentTrainerUid !=
                        trainerList[currentIndexofTrainerName].uid)) {
                  GymUserDBService.removeTrainne(
                      widget.gymUser.uid, currentTrainerUid);
                }

                setState(() {
                  currentTrainerName = _trainerController.text;
                  currentTrainerUid =
                      trainerList[currentIndexofTrainerName].uid;
                });

                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void removeTrainerFromUserConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "!You sure want to Remove this Trainer from User?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));

                var currentIndexofTrainerName =
                    trainerName.indexOf(_trainerController.text);

                GymUserDBService.removeTrainne(widget.gymUser.uid,
                    trainerList[currentIndexofTrainerName].uid);

                GymUserDBService.removeTrainner(widget.gymUser.uid);

                setState(() {
                  currentTrainerName = "";
                  //currentTrainerUid = "";
                });

                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void assingMembershipConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "!You sure want to Assign this membership to user?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));

                var currentIndexofMembershipType =
                    membershipType.indexOf(_membershipController.text);
                GymUser updMembershipUser = GymUser();
                updMembershipUser.uid = widget.gymUser.uid;
                updMembershipUser.currentMembershipId =
                    membershipList[currentIndexofMembershipType].mid;
                updMembershipUser.currentMembershipName =
                    membershipList[currentIndexofMembershipType].membershipType;
                updMembershipUser.membershipStartDate = startDate;
                updMembershipUser.membershipEndDate = endDate;
                if ((startDate != "Start Date") && (endDate != "End Date")) {
                  //Proceed only if start date and end date is not null
                  GymUserDBService.assignMembershipData(updMembershipUser);
                  setState(() {
                    stateMembershipName =
                        updMembershipUser.currentMembershipName;
                    //currentTrainerUid = "";
                  });
                } else {
                  scaffoldUtil(
                      context, "Please Choose Start Date and End Date", 1);
                }

                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void removeMembershipConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "!You sure want to Remove this membership to user?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));

                GymUser updMembershipUser = GymUser();
                updMembershipUser.uid = widget.gymUser.uid;
                updMembershipUser.currentMembershipId = null;
                updMembershipUser.currentMembershipName = null;
                updMembershipUser.membershipStartDate = null;
                updMembershipUser.membershipEndDate = null;
                GymUserDBService.assignMembershipData(updMembershipUser);
                setState(() {
                  stateMembershipName = null;
                  startDate = "Start Date";
                  endDate = "End Date";
                  //currentTrainerUid = "";
                });

                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void updateMembershipConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "!You sure want to Update this membership to user?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));

                var currentIndexofMembershipType =
                    membershipType.indexOf(_membershipController.text);
                GymUser updMembershipUser = GymUser();
                updMembershipUser.uid = widget.gymUser.uid;
                updMembershipUser.currentMembershipId =
                    membershipList[currentIndexofMembershipType].mid;
                updMembershipUser.currentMembershipName =
                    membershipList[currentIndexofMembershipType].membershipType;
                updMembershipUser.membershipStartDate = startDate;
                updMembershipUser.membershipEndDate = endDate;
                GymUserDBService.assignMembershipData(updMembershipUser);
                setState(() {
                  stateMembershipName = updMembershipUser.currentMembershipName;
                  //currentTrainerUid = "";
                });

                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void historyMembershipConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "!You sure want to stop and put into history this membership to user?")),
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
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(Duration(seconds: 2));

                if ((startDate != "Start Date") && (endDate != "End Date")) {
                  var currentIndexofMembershipType =
                      membershipType.indexOf(_membershipController.text);
                  GymUser updMembershipUser = GymUser();
                  updMembershipUser.uid = widget.gymUser.uid;
                  updMembershipUser.currentMembershipId =
                      membershipList[currentIndexofMembershipType].mid;
                  updMembershipUser.currentMembershipName =
                      membershipList[currentIndexofMembershipType]
                          .membershipType;
                  updMembershipUser.membershipStartDate = startDate;
                  updMembershipUser.membershipEndDate = endDate;
                  GymUserDBService.assignMembershipHistroy(
                      updMembershipUser,
                      membershipList[currentIndexofMembershipType]
                          .membershipDescription); // Assign membership record to gym user collection

                  setState(() {
                    stateMembershipName = null;
                    startDate = "Start Date";
                    endDate = "End Date";
                    //currentTrainerUid = "";
                  });
                  updMembershipUser.currentMembershipId = null;
                  updMembershipUser.currentMembershipName = null;
                  updMembershipUser.membershipEndDate = null;
                  updMembershipUser.membershipStartDate = null;

                  GymUserDBService.assignMembershipData(updMembershipUser);
                } else {
                  scaffoldUtil(
                      context, "Please choose Start Date and End Date", 1);
                }

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
