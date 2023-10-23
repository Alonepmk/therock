// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/activities.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/services/activity_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class UdActivity extends StatefulWidget {
  final Activity activity;
  final String pid;
  const UdActivity({Key? key, required this.activity, required this.pid})
      : super(key: key);
  @override
  State<UdActivity> createState() => _UdActivityState();
}

class _UdActivityState extends State<UdActivity> {
  double screenWidth = 0;
  double screenHeight = 0;
  TextEditingController _activityNameController = TextEditingController();
  TextEditingController _activityDescriptionController =
      TextEditingController();
  TextEditingController _videoLinkController = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    super.initState();
    debugPrint("the aid is ${widget.activity.aid}");
    _activityNameController =
        TextEditingController(text: widget.activity.activityName);
    _activityDescriptionController =
        TextEditingController(text: widget.activity.activityDescription);
    _videoLinkController =
        TextEditingController(text: widget.activity.videoLink);
  }

  void _updateActivity(String activityName, String activityDescription,
      String videoLink, BuildContext context) async {
    showLoadingDialogUtil(context);
    Activity activity = Activity(
      aid: widget.activity.aid,
      activityName: activityName,
      activityDescription: activityDescription,
      videoLink: videoLink,
      activityCreatedDate: Timestamp.now(),
    );
    rds.status = await ActivityDBService.updateActivity(activity, widget.pid);
    if (rds.status == "success") {
      scaffoldUtil(context, "Successfully updated the data", 1);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      scaffoldUtil(context, "Something went wrong", 1);
      Navigator.pop(context);
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
            title: const Text("Update Activity"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: BoxContainerUtil(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _activityNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Activity Name",
                            hintText: "Activity Name",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _activityDescriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Activity Description",
                            hintText: "Activity Description",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _videoLinkController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Video Link",
                            hintText: "Video Link",
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            updateActivitiyConfirmDialog(context);
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
                                  Icons.update_sharp,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateActivitiyConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text("!You sure want to Update this Activity?")),
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
                await Future.delayed(const Duration(seconds: 2));

                FocusManager.instance.primaryFocus?.unfocus();

                if (_activityNameController.text == "") {
                  scaffoldUtil(context, "Please fill the video link", 1);
                } else if (_videoLinkController.text == "") {
                  scaffoldUtil(context, "Please fill the video link", 1);
                } else if (_activityDescriptionController.text == "") {
                  scaffoldUtil(context, "Please fill the video link", 1);
                } else {
                  _updateActivity(
                      _activityNameController.text,
                      _activityDescriptionController.text,
                      _videoLinkController.text,
                      context);
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
