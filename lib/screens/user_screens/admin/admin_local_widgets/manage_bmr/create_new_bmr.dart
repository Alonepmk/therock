// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class CreateNewBmr extends StatefulWidget {
  final GymUser gymUser;
  const CreateNewBmr({Key? key, required this.gymUser}) : super(key: key);

  @override
  State<CreateNewBmr> createState() => _CreateNewBmrState();
}

class _CreateNewBmrState extends State<CreateNewBmr> {
  double screenWidth = 0;
  double screenHeight = 0;

  String date = "Date";
  String month = "";
  String year = "";

  TextEditingController bmrPicLinkController = TextEditingController();

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
            title: const Text("Create User's BMR Record"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BoxContainerUtil(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: bmrPicLinkController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "BMR Pic Link",
                        hintText: "BMR Pic Link",
                        suffixIcon: IconButton(
                          onPressed: bmrPicLinkController.clear,
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                    padding: const EdgeInsets.only(top: 10.0),
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
                              date = DateFormat('MMMM yyyy').format(value);
                              month = DateFormat('MMMM').format(value);
                              year = DateFormat('yyyy').format(value);
                            });
                            print(date);
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
                            date,
                            style: const TextStyle(
                              color: Color.fromARGB(77, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () async {
                        showLoadingDialogUtil(context);
                        if (bmrPicLinkController.text != "" && date != "Date") {
                          DocumentSnapshot snap = await FirebaseFirestore
                              .instance
                              .collection("users")
                              .doc(widget.gymUser.uid)
                              .collection("user_bmr")
                              .doc(date)
                              .get();

                          if (snap.data() != null) {
                            scaffoldUtil(context,
                                "Data Already Exists, Please Update it!", 1);
                          } else {
                            String splitted = "";
                            if (bmrPicLinkController.text.contains("export")) {
                              splitted = bmrPicLinkController.text;
                            } else {
                              List<String> tempStr =
                                  bmrPicLinkController.text.split('/');
                              splitted =
                                  "https://drive.google.com/uc?export=view&id=${tempStr[5]}";
                            }

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.gymUser.uid)
                                .collection("user_bmr")
                                .doc(date)
                                .set({
                              'createdDate': Timestamp.now(),
                              'bmrPicLink': splitted,
                              'date': date,
                              'month': month,
                              'year': year,
                            }, SetOptions(merge: true));
                            scaffoldUtil(
                                context, "Data Successfully Added!", 1);
                            Navigator.pop(context);
                          }
                        } else {
                          scaffoldUtil(context, "Fields must not be empty", 1);
                        }
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
                              "Create",
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
            ),
          ),
        ),
      ),
    );
  }
}
