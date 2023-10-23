// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:therock/models/activities.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/services/activity_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class CreateAnewActivity extends StatefulWidget {
  final pid;
  const CreateAnewActivity({Key? key, required this.pid}) : super(key: key);

  @override
  State<CreateAnewActivity> createState() => _CreateAnewActivityState();
}

class _CreateAnewActivityState extends State<CreateAnewActivity> {
  TextEditingController activityNameController = TextEditingController();
  TextEditingController activityDescriptionController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    super.initState();
  }

  void _createAnewActivity(String activityName, String activityDescription,
      String videoLink, BuildContext context) async {
    showLoadingDialogUtil(context);
    Activity activity = Activity(
        activityName: activityName,
        activityDescription: activityDescription,
        videoLink: videoLink);
    rds.status = await ActivityDBService.createActivity(activity, widget.pid);
    if (rds.status == "success") {
      scaffoldUtil(context, "Successfully added the data", 1);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      scaffoldUtil(context, "Something went wrong", 1);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create a new Activity"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BoxContainerUtil(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: activityNameController,
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
                          controller: activityDescriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Activity Description",
                            hintText: "Activity Description",
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: videoLinkController,
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
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (activityNameController.text == "") {
                              scaffoldUtil(
                                  context, "Please fill the activity name", 1);
                            } else if (activityDescriptionController.text ==
                                "") {
                              scaffoldUtil(context,
                                  "Please fill the activity description", 1);
                            } else if (videoLinkController.text == "") {
                              scaffoldUtil(context,
                                  "Please fill the youtube video link", 1);
                            } else {
                              _createAnewActivity(
                                  activityNameController.text,
                                  activityDescriptionController.text,
                                  videoLinkController.text,
                                  context);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createActivitiyConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text("!You sure want to Create this Activity?")),
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

                if (activityNameController.text == "") {
                  scaffoldUtil(context, "Please fill the activity name", 1);
                } else if (activityDescriptionController.text == "") {
                  scaffoldUtil(
                      context, "Please fill the activity description", 1);
                } else if (videoLinkController.text == "") {
                  scaffoldUtil(
                      context, "Please fill the youtube video link", 1);
                } else {
                  _createAnewActivity(
                      activityNameController.text,
                      activityDescriptionController.text,
                      videoLinkController.text,
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
