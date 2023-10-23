import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/trainer_show_profile.dart';

class TrainerProfileDBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String> createOrUpdateTrainerShowProfile(
      TrainerShowProfile trainerProfile) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance
          .collection("trainer_show_profile")
          .doc(trainerProfile.tid)
          .set(
        {
          "tid": trainerProfile.tid,
          "nickName": trainerProfile.nickName,
          "contactEmail": trainerProfile.contactEmail,
          "contactNumber": trainerProfile.contactNumber,
          "bio": trainerProfile.bio,
          "profileLink": trainerProfile.profileLink,
          "showPicOne": trainerProfile.showPicOne,
          "showPicTwo": trainerProfile.showPicTwo,
          "showPicThree": trainerProfile.showPicThree,
          "trainerProfileCreatedDate": Timestamp.now(),
        },
        SetOptions(merge: true),
      ); //insert trainerProfile record to firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  static Future<TrainerShowProfile> getUserTrainerInfoByInitState(
      String? tid) async {
    TrainerShowProfile tsp = TrainerShowProfile();
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("trainer_show_profile")
          .doc(tid)
          .get();

      tsp.tid = docSnapshot.get("tid");
      tsp.nickName = docSnapshot.get("nickName");
      tsp.contactEmail = docSnapshot.get("contactEmail");
      tsp.contactNumber = docSnapshot.get("contactNumber");
      tsp.bio = docSnapshot.get("bio");
      tsp.profileLink = docSnapshot.get("profileLink");
      tsp.showPicOne = docSnapshot.get("showPicOne");
      tsp.showPicTwo = docSnapshot.get("showPicTwo");
      tsp.showPicThree = docSnapshot.get("showPicThree");
      tsp.trainerProfileCreatedDate =
          docSnapshot.get("trainerProfileCreatedDate");
    } catch (e) {
      debugPrint(e.toString());
    }

    return tsp;
  }
}
