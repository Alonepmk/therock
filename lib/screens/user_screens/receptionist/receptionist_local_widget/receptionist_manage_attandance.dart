// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class ReceptionistManageAttandance extends StatefulWidget {
  const ReceptionistManageAttandance({super.key});

  @override
  State<ReceptionistManageAttandance> createState() =>
      _ReceptionistManageAttandanceState();
}

class _ReceptionistManageAttandanceState
    extends State<ReceptionistManageAttandance> {
  double screenWidth = 0;
  double screenHeight = 0;
  String filterName = "";
  String filterEmail = "";
  String filterType = "";
  List<GymUser> searchResult = [];
  TextEditingController paramTextBoxController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    //filterData = myData;
    //print(myData.toList());
    super.initState();
  }

  void doSearchAndInitUser(String param) async {
    List<GymUser> tempResult = [];
    if (filterType == "name") {
      tempResult = await GymUserDBService.readUserByName(param);
    } else if (filterType == "email") {
      tempResult = await GymUserDBService.readUserByEmail(param);
    } else {
      tempResult = await GymUserDBService.readUserByPhone(param);
    }

    setState(() {
      searchResult = tempResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Align(
                  child: Text(
                    "Manage Attandance",
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                    child: Text(
                      "Filter By : ",
                      style: TextStyle(
                        fontSize: screenWidth / 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: screenWidth / 4.5,
                          height: screenHeight / 16,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                filterType = "name";
                                paramTextBoxController.text = "";
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blue.shade400),
                            ),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: screenWidth / 35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 4.5,
                          height: screenHeight / 16,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                filterType = "email";
                                paramTextBoxController.text = "";
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blue.shade400),
                            ),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: screenWidth / 35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 4.5,
                          height: screenHeight / 16,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                filterType = "phone";
                                paramTextBoxController.text = "";
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blue.shade400),
                            ),
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                fontSize: screenWidth / 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  filterType != ""
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BoxContainerUtil(
                            child: Column(
                              children: [
                                Text(
                                    "Search By '$filterType' Contains Or Equals"),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: paramTextBoxController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: filterType,
                                    hintText: filterType,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (paramTextBoxController
                                        .text.isNotEmpty) {
                                      if (filterType == "phone") {
                                        if (paramTextBoxController
                                                .text.length >=
                                            4) {
                                          doSearchAndInitUser(
                                              paramTextBoxController.text
                                                  .trim());
                                        } else {
                                          scaffoldUtil(
                                              context,
                                              "Phone Number Length must be at least 4 digit",
                                              1);
                                        }
                                      } else {
                                        doSearchAndInitUser(
                                            paramTextBoxController.text.trim());
                                      }
                                    } else {
                                      scaffoldUtil(context,
                                          "Search Data Must not be empty", 1);
                                    }
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
                                          Icons.search_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Search",
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
                          ),
                        )
                      : const Text('"Choose a Filter Type First"'),
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(8.0),
                          child: searchResult.isNotEmpty
                              ? const Text("Search Result")
                              : const Text("No Search Data Found!"),
                        ),
                        const Divider(),
                        searchResult.isNotEmpty
                            ? ListView.builder(
                                itemCount: searchResult.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onLongPress: () async {
                                      DocumentSnapshot snap =
                                          await FirebaseFirestore.instance
                                              .collection("daily_activities")
                                              .doc(DateFormat('dd MMMM yyyy')
                                                  .format(DateTime.now()))
                                              .collection("Attandance")
                                              .doc(searchResult[index].uid)
                                              .get();
                                      bool isSelectedUserCheckIn = false;
                                      bool isSelectedUserCheckOut = false;

                                      if (snap.data() != null) {
                                        isSelectedUserCheckIn = true;
                                        if (snap["checkOut"] != "--/--") {
                                          isSelectedUserCheckOut = true;
                                        }
                                      }

                                      showUserCheckInOutStatus(
                                          searchResult[index],
                                          isSelectedUserCheckIn,
                                          isSelectedUserCheckOut);
                                    },
                                    child: searchResult[index]
                                                .role
                                                .toString() !=
                                            "admin"
                                        ? ListTile(
                                            leading: Text(
                                              searchResult[index]
                                                  .fullName
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 30,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            title: Text(
                                              searchResult[index]
                                                  .email
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            subtitle: Text(
                                              searchResult[index]
                                                  .phoneNumber
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            trailing: FittedBox(
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Start Date",
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth / 35,
                                                        ),
                                                        textWidthBasis:
                                                            TextWidthBasis
                                                                .longestLine,
                                                      ),
                                                      Text(
                                                        searchResult[index]
                                                            .membershipStartDate
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth / 35,
                                                        ),
                                                        textWidthBasis:
                                                            TextWidthBasis
                                                                .longestLine,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "End Date",
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth / 35,
                                                        ),
                                                        textWidthBasis:
                                                            TextWidthBasis
                                                                .longestLine,
                                                      ),
                                                      Text(
                                                        searchResult[index]
                                                            .membershipEndDate
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth / 35,
                                                        ),
                                                        textWidthBasis:
                                                            TextWidthBasis
                                                                .longestLine,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  );
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Attandance Record for ${DateFormat('dd MMMM yyyy').format(DateTime.now())}"),
                        ),
                        const Divider(),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("daily_activities")
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()))
                                .collection("Attandance")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final snap = snapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: snap.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Text(
                                        snap[index]['fullName'].toString(),
                                        style: TextStyle(
                                          fontSize: screenWidth / 30,
                                        ),
                                        textWidthBasis:
                                            TextWidthBasis.longestLine,
                                      ),
                                      title: Text(
                                        snap[index]['email'].toString(),
                                        style: TextStyle(
                                          fontSize: screenWidth / 35,
                                        ),
                                        textWidthBasis:
                                            TextWidthBasis.longestLine,
                                      ),
                                      trailing: FittedBox(
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Check-in",
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 30,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                                Text(
                                                  snap[index]['checkIn']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 30,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onLongPress: () {
                                                if (snap[index]['checkOut']
                                                        .toString() ==
                                                    "--/--") {
                                                  showUserCheckOut(
                                                      snap[index].id);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Check-out",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth / 30,
                                                    ),
                                                    textWidthBasis:
                                                        TextWidthBasis
                                                            .longestLine,
                                                  ),
                                                  Text(
                                                    snap[index]['checkOut']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth / 30,
                                                    ),
                                                    textWidthBasis:
                                                        TextWidthBasis
                                                            .longestLine,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showUserCheckInOutStatus(GymUser selectedUser,
      bool isSelectedUserCheckIn, bool isSelectedUserCheckOut) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('User Attandance Status'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Check-in"),
                    Text("Check-out"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isSelectedUserCheckIn
                        ? const Icon(Icons.check_outlined)
                        : IconButton(
                            onPressed: () async {
                              try {
                                showLoadingDialogUtil(context);
                                if (selectedUser.role == "currentUser" ||
                                    selectedUser.role == "trainer") {
                                  //add attandance record for user collection
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(selectedUser.uid)
                                      .collection("Attandance")
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .set({
                                    'date': Timestamp.now(),
                                    'checkIn': DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                    'checkOut': "--/--",
                                  }, SetOptions(merge: true));

                                  //add inside the gym daily activity report
                                  await FirebaseFirestore.instance
                                      .collection("daily_activities")
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .collection("Attandance")
                                      .doc(selectedUser.uid)
                                      .set({
                                    'fullName': selectedUser.fullName,
                                    'email': selectedUser.email,
                                    'date': Timestamp.now(),
                                    'checkIn': DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                    'checkOut': "--/--",
                                  }, SetOptions(merge: true));

                                  scaffoldUtil(
                                      context, "Successfully Check-in", 1);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  scaffoldUtil(context, "Invalid User", 1);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                scaffoldUtil(context, e.toString(), 1);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.add_box)),
                    isSelectedUserCheckOut
                        ? const Icon(Icons.check_outlined)
                        : IconButton(
                            onPressed: () async {
                              if (!isSelectedUserCheckIn) {
                                scaffoldUtil(
                                    context, "You must check-in first", 1);
                              } else {
                                try {
                                  showLoadingDialogUtil(context);
                                  if (selectedUser.role == "currentUser" ||
                                      selectedUser.role == "trainer") {
                                    //add attandance record for user collection
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(selectedUser.uid)
                                        .collection("Attandance")
                                        .doc(DateFormat('dd MMMM yyyy')
                                            .format(DateTime.now()))
                                        .set({
                                      'date': Timestamp.now(),
                                      'checkOut': DateFormat('hh:mm')
                                          .format(DateTime.now()),
                                    }, SetOptions(merge: true));

                                    //add inside the gym daily activity report
                                    await FirebaseFirestore.instance
                                        .collection("daily_activities")
                                        .doc(DateFormat('dd MMMM yyyy')
                                            .format(DateTime.now()))
                                        .collection("Attandance")
                                        .doc(selectedUser.uid)
                                        .set({
                                      'fullName': selectedUser.fullName,
                                      'email': selectedUser.email,
                                      'date': Timestamp.now(),
                                      'checkOut': DateFormat('hh:mm')
                                          .format(DateTime.now()),
                                    }, SetOptions(merge: true));

                                    scaffoldUtil(
                                        context, "Successfully Check-out", 1);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    scaffoldUtil(context, "Invalid User", 1);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  scaffoldUtil(context, e.toString(), 1);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            icon: const Icon(Icons.add_box)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showUserCheckOut(String uid) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('User Attandance'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Check-out"),
                IconButton(
                  onPressed: () async {
                    showLoadingDialogUtil(context);
                    //add attandance record for user collection
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("Attandance")
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                        .set({
                      'date': Timestamp.now(),
                      'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                    }, SetOptions(merge: true));

                    //add inside the gym daily activity report
                    await FirebaseFirestore.instance
                        .collection("daily_activities")
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                        .collection("Attandance")
                        .doc(uid)
                        .set({
                      'date': Timestamp.now(),
                      'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                    }, SetOptions(merge: true));

                    scaffoldUtil(context, "Successfully Check-out", 1);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_box),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
