// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/user_screens/member_shared_screens/account_setting.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/utils/function_utils.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  double screenWidth = 0;
  double screenHeight = 0;
  static GymUser user = GymUser();
  String birth = "Date of birth";
  String profilePic = "";

  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _initiateUserData();
  }

  void _initiateUserData() async {
    user = await GymUserDBService().getUserInfoByInitState();

    fullNameController.text = user.fullName.toString();
    addressController.text = user.address.toString();
    phoneNumberController.text = user.phoneNumber.toString();

    birth = user.dob.toString();

    if (user.profilePicLink != null) {
      setState(() {
        profilePic = user.profilePicLink!;
      });
    }

    // print("the profile pics ssssssss${profilePic}");
  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 80,
    );
    showLoadingDialogUtil(context);
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${user.uid!.toLowerCase()}_profilepic.jpg");
    if (image != null) {
      await ref.putFile(File(image.path));

      ref.getDownloadURL().then((value) async {
        setState(() {
          profilePic = value;
        });
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          'profilePicLink': value,
        });
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //CurrentUser cu = Provider.of<CurrentUser>(context, listen: true);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight / 4,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight / 6.2,
                  decoration: BoxDecoration(
                    //backgroundBlendMode: BlendMode.luminosity,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(110.0),
                      // bottomLeft: Radius.circular(80.0),
                    ),
                    //color: Color.fromARGB(181, 2, 52, 49),
                    color: '#D9E7CB'.toColor(),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.teal.shade400,
                          // spreadRadius: 2,
                          blurRadius: 5.0,
                          offset: const Offset(0.0, 0.75))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: screenHeight / 6.4,
                  decoration: BoxDecoration(
                    //backgroundBlendMode: BlendMode.dstIn,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(110.0),
                      // bottomLeft: Radius.circular(80.0),
                    ),

                    color: Colors.grey.shade900,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.white,
                    tooltip: 'Log Out',
                    onPressed: () {
                      showConfirmDialog(context);
                    },
                  ),
                ),
                Positioned(
                  left: screenWidth / 40,
                  top: screenHeight / 16,
                  child: GestureDetector(
                    onTap: () {
                      pickUploadProfilePic();
                    },
                    child: profilePic == ""
                        ? CircleAvatar(
                            radius: screenWidth / 13.8,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: screenWidth / 9.25,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: profilePic.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.teal.shade400,
                                      blurRadius: 5.0,
                                      offset: const Offset(0.0, 0.75))
                                ],
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: screenWidth / 14,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                  ),
                ),
                Positioned(
                  top: screenHeight / 4,
                  left: screenWidth / 40,
                  child: Row(
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: screenWidth / 36,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.app_registration_outlined,
                        color: Colors.white,
                        size: screenWidth / 36,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenWidth / 10.5,
                  left: screenWidth / 5.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.diamond_sharp,
                            color: Colors.white30,
                            size: screenWidth / 50,
                          ),
                          Text(
                            " ${user.fullName.toString().toUpperCase()}",
                            style: TextStyle(
                              fontSize: screenWidth / 65,
                              color: Colors.white30,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.alternate_email_outlined,
                            color: Colors.white30,
                            size: screenWidth / 50,
                          ),
                          Text(
                            "${user.email}",
                            style: TextStyle(
                              fontSize: screenWidth / 65,
                              color: Colors.white30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth / 22, screenWidth / 40, 0, screenWidth / 100),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  textField(
                      user.fullName,
                      "Full Name",
                      fullNameController,
                      Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                        size: screenWidth / 40,
                      )),
                  textField(
                      user.address,
                      "Address",
                      addressController,
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: screenWidth / 40,
                      )),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Date of Birth",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SizedBox(
                                    height: screenHeight / 2,
                                    width: screenWidth / 2,
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
                            birth = DateFormat("MM/dd/yyyy").format(value);
                          });
                        }
                      });
                    },
                    child: Container(
                      height: kToolbarHeight - 20,
                      width: screenWidth,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.only(left: 11),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900.withOpacity(0.9),
                        // borderRadius: const BorderRadius.only(
                        //   bottomRight: Radius.elliptical(8, 8),
                        //   topRight: Radius.elliptical(8, 8),
                        // ),
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: Colors.white,
                              size: screenWidth / 40,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              birth,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth / 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  textField(
                      user.phoneNumber,
                      "Phone Number",
                      phoneNumberController,
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: screenWidth / 40,
                      )),
                  GestureDetector(
                    onTap: () async {
                      String fullName = fullNameController.text;
                      String address = addressController.text;
                      String birthDate = birth;
                      String phoneNumber = phoneNumberController.text;
                      if (fullName.isEmpty) {
                        scaffoldUtil(
                            context, "Please enter your full name!", 2);
                      } else if (address.isEmpty) {
                        scaffoldUtil(context, "Please enter your address!", 2);
                      } else if (birthDate.isEmpty) {
                        scaffoldUtil(context, "Please enter your address!", 2);
                      } else if (phoneNumber.isEmpty) {
                        scaffoldUtil(
                            context, "Please enter your phone number", 2);
                      } else {
                        try {
                          showLoadingDialogUtil(context);
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.uid)
                              .update({
                            'fullName': fullName,
                            'address': address,
                            'dob': birthDate,
                            'phoneNumber': phoneNumber,
                          }).then((value) {});

                          Navigator.pop(context);
                          scaffoldUtil(context, "Data Successfully Updated", 2);
                        } catch (e) {
                          scaffoldUtil(context, "Error Updating Data", 2);
                        }
                      }
                    },
                    child: Container(
                      height: kToolbarHeight - 22,
                      margin: EdgeInsets.fromLTRB(
                          screenWidth / 4, screenWidth / 35, 0, 0),
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //     color: Colors.white.withOpacity(0.9),
                        //     blurRadius: 2.0,
                        //   )
                        // ],
                        color: Colors.blueGrey.shade400,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.save_as_outlined,
                            color: Colors.white,
                            size: screenWidth / 40,
                          ),
                          const SizedBox(width: 12),
                          Center(
                            child: Text(
                              "Save Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth / 55,
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
          Column(
            children: [
              Text(
                "Account Setting",
                style: TextStyle(
                  fontSize: screenWidth / 80,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                color: Colors.white,
                tooltip: 'Log Out',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const SingleChildScrollView(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      "!You sure want to Proceed to Account Setting?")),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.to(() => const AccountSetting());
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textField(String? hint, String? title,
      TextEditingController controller, Widget iconWidget) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: kToolbarHeight - 20,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.9),
            // boxShadow: <BoxShadow>[
            //   BoxShadow(
            //     color: Colors.white.withOpacity(0.6),
            //     blurRadius: 1.0,
            //   ),
            // ],
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(color: Colors.white, fontSize: screenWidth / 60),
            controller: controller,
            cursorColor: Colors.white,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: iconWidget,
              hintText: title,
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
              enabledBorder: const OutlineInputBorder(
                // borderRadius: BorderRadius.only(
                //   bottomRight: Radius.elliptical(8, 8),
                //   topRight: Radius.elliptical(8, 8),
                // ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
