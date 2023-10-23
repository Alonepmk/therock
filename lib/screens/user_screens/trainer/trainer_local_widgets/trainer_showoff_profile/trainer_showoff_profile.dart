// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/models/trainer_show_profile.dart';
import 'package:therock/services/trainer_profile_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';
import 'package:provider/provider.dart';

class TrainerShowoffProfile extends StatefulWidget {
  final String tid;
  const TrainerShowoffProfile({Key? key, required this.tid}) : super(key: key);

  @override
  State<TrainerShowoffProfile> createState() => _TrainerShowoffProfileState();
}

class _TrainerShowoffProfileState extends State<TrainerShowoffProfile> {
  double screenWidth = 0;
  double screenHeight = 0;

  TextEditingController nickName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController contactEmail = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController profilePic = TextEditingController();
  TextEditingController showPicOne = TextEditingController();
  TextEditingController showPicTwo = TextEditingController();
  TextEditingController showPicThree = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    _initTrainerShowProfileState();
    super.initState();
  }

  Future<void> _initTrainerShowProfileState() async {
    TrainerShowProfile tsp =
        await TrainerProfileDBService.getUserTrainerInfoByInitState(widget.tid);

    nickName.text = tsp.nickName.toString();
    contactEmail.text = tsp.contactEmail.toString();
    contactNumber.text = tsp.contactNumber.toString();
    bio.text = tsp.bio.toString();
    profilePic.text = tsp.profileLink.toString();
    showPicOne.text = tsp.showPicOne.toString();
    showPicTwo.text = tsp.showPicTwo.toString();
    showPicThree.text = tsp.showPicThree.toString();
  }

  Future<void> _updateOrCreateTrainerProfile(
      TrainerShowProfile trainerShowProfile) async {
    showLoadingDialogUtil(context);
    await Future.delayed(const Duration(seconds: 1));
    TrainerProfileDBService.createOrUpdateTrainerShowProfile(
        trainerShowProfile);
    Navigator.pop(context);
    scaffoldUtil(context, "Data Successfully Updated", 1);
  }

  String googleDriveStringSplitter(String link) {
    String splitted = "";
    if (link.contains("export")) {
      splitted = link;
    } else {
      List<String> tempStr = link.split('/');
      splitted = "https://drive.google.com/uc?export=view&id=${tempStr[5]}";
    }
    return splitted;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: '#141414'.toColor(),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800.withOpacity(0.5),
          title: Row(
            children: [
              Align(
                child: Text(
                  "Showoff  Profile",
                  style: TextStyle(
                    fontSize: screenWidth / 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BoxContainerUtil(
              child: Column(
                children: [
                  TextFormField(
                    controller: nickName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nick Name",
                      hintText: "Nick Name",
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: contactEmail,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contact Email",
                      hintText: "Contact Email",
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: contactNumber,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contact Number",
                      hintText: "Contact Number",
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: bio,
                    textAlign: TextAlign.justify,
                    minLines: 15,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Bio",
                      hintText: "Bio",
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: profilePic,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Profile Picture Link",
                      hintText: "Profile Picture Link",
                      suffixIcon: IconButton(
                        onPressed: profilePic.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: showPicOne,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Show Picture 1",
                      hintText: "CMS Pic Link",
                      suffixIcon: IconButton(
                        onPressed: showPicOne.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: showPicTwo,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Show Picture 2",
                      hintText: "Show Picture 2",
                      suffixIcon: IconButton(
                        onPressed: showPicTwo.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: showPicThree,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Show Picture 3",
                      hintText: "Show Picture 3",
                      suffixIcon: IconButton(
                        onPressed: showPicThree.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "trainer_showoff_profile_update_button",
                    onPressed: () {
                      //showResetConfirmDialog(context);
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (nickName.text == "") {
                        scaffoldUtil(context, "Please fill the Nick Name", 1);
                      } else if (contactEmail.text == "") {
                        scaffoldUtil(
                            context, "Please fill the Contact Email", 1);
                      } else if (contactNumber.text == "") {
                        scaffoldUtil(
                            context, "Please fill the Contact Number", 1);
                      } else if (bio.text == "") {
                        scaffoldUtil(context, "Please fill the Bio", 1);
                      } else if (profilePic.text == "") {
                        scaffoldUtil(context,
                            "Please fill the Google drive Profile Pic Link", 1);
                      } else if (!profilePic.text
                          .contains("https://drive.google.com")) {
                        scaffoldUtil(
                            context,
                            "Please fill the Apporiate Google drive Profile Pic Link",
                            1);
                      } else if (showPicOne.text == "") {
                        scaffoldUtil(
                            context, "Please fill the Show Pics 1 Link", 1);
                      } else if (showPicTwo.text == "") {
                        scaffoldUtil(
                            context, "Please fill the Show Pics 2 Link", 1);
                      } else if (showPicThree.text == "") {
                        scaffoldUtil(
                            context, "Please fill the Show Pics 3 Link", 1);
                      } else if (!showPicOne.text
                          .contains("https://drive.google.com")) {
                        scaffoldUtil(
                            context,
                            "Please fill the  Apporiate Google drive Show Pics 1 Link",
                            1);
                      } else if (!showPicTwo.text
                          .contains("https://drive.google.com")) {
                        scaffoldUtil(
                            context,
                            "Please fill the  Apporiate Google drive Show Pics 2 Link",
                            1);
                      } else if (!showPicThree.text
                          .contains("https://drive.google.com")) {
                        scaffoldUtil(
                            context,
                            "Please fill the  Apporiate Google drive Show Pics 3 Link",
                            1);
                      } else {
                        TrainerShowProfile tsp = TrainerShowProfile(
                          tid: currentUser.getCurrentUser.uid,
                          nickName: nickName.text,
                          contactEmail: contactEmail.text,
                          contactNumber: contactNumber.text,
                          bio: bio.text,
                          profileLink:
                              googleDriveStringSplitter(profilePic.text),
                          showPicOne:
                              googleDriveStringSplitter(showPicOne.text),
                          showPicTwo:
                              googleDriveStringSplitter(showPicTwo.text),
                          showPicThree:
                              googleDriveStringSplitter(showPicThree.text),
                        );
                        _updateOrCreateTrainerProfile(tsp);
                      }
                    },
                    label: const Text('Update'),
                    icon: const Icon(Icons.add_circle_outline),
                    backgroundColor: Colors.blueGrey.shade400,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     FocusManager.instance.primaryFocus?.unfocus();

                  //     if (_cmsDescription.text == "") {
                  //       scaffoldUtil(
                  //           context, "Please fill the cms Description", 1);
                  //     } else if (_cmsPicLink.text == "") {
                  //       scaffoldUtil(context,
                  //           "Please fill the CMS Picture Google drive link", 1);
                  //     } else if (_cmsTitle.text == "") {
                  //       scaffoldUtil(context, "Please fill the CMS Title", 1);
                  //     } else {
                  //       _updateCms(_cmsName.text, _cmsTitle.text,
                  //           _cmsDescription.text, _cmsPicLink.text);
                  //     }
                  //   },
                  //   child: Container(
                  //     width: 100,
                  //     height: 30,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: Colors.green,
                  //     ),
                  //     child: const Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(
                  //           Icons.add,
                  //           color: Colors.white,
                  //         ),
                  //         SizedBox(
                  //           width: 5,
                  //         ),
                  //         Text(
                  //           "Update",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
