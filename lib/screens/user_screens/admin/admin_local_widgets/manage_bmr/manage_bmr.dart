// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_bmr/create_new_bmr.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_bmr/ud_bmr.dart';
import 'package:therock/widgets/box_container_util.dart';

class ManageBmr extends StatefulWidget {
  final GymUser gymUser;
  const ManageBmr({Key? key, required this.gymUser}) : super(key: key);

  @override
  State<ManageBmr> createState() => _ManageBmrState();
}

class _ManageBmrState extends State<ManageBmr> {
  double screenWidth = 0;
  double screenHeight = 0;

  String year = "Year";

  @override
  void initState() {
    super.initState();
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
            title: const Text("Manage User's BMR Record"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  BoxContainerUtil(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            showMonthYearPicker(
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
                                            const EdgeInsets.only(top: 10.0),
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
                                  year = DateFormat('yyyy').format(value);
                                });
                                print(year);
                              }
                            });
                          },
                          child: Container(
                            height: kToolbarHeight,
                            width: screenWidth * 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.only(left: 11),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color.fromARGB(137, 39, 37, 37),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                year,
                                style: const TextStyle(
                                  color: Color.fromARGB(77, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Text("BMR Record for the year $year"),
                        ),
                        const Divider(),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.gymUser.uid)
                                .collection("user_bmr")
                                .where("year", isEqualTo: year)
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
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: screenWidth / 3,
                                            child: Text(
                                              snap[index]['date'].toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 30,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        snap[index]['bmrPicLink'].toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: screenWidth / 35,
                                        ),
                                        textWidthBasis:
                                            TextWidthBasis.longestLine,
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Get.to(
                                              () => UdBmr(
                                                gymUser: widget.gymUser,
                                                bmrLink: snap[index]
                                                        ['bmrPicLink']
                                                    .toString(),
                                                date: snap[index]['date']
                                                    .toString(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.update)),
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
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            tooltip: "Create a User",
            elevation: 3,
            backgroundColor: Colors.pink.withOpacity(0.4),
            child: const Icon(Icons.add_outlined),
            onPressed: () {
              Get.to(
                () => CreateNewBmr(gymUser: widget.gymUser),
              );
            },
          ),
        ),
      ),
    );
  }
}
