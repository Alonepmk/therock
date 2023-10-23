import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/program.dart';

class FeedbackDBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String> createFeedBack(Feedback feedback) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance.collection("feedbacks").doc().set({
        'feedBackCreatedDate': Timestamp.now(),
      }); //insert sign up user record to firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  static Stream<List<Program>> read() {
    final programCollection = FirebaseFirestore.instance
        .collection("programs")
        .orderBy("programCreatedDate");

    return programCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Program.fromSnapshot(e)).toList());
  }

  static Future<String> updateProgram(Program program) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance
          .collection("programs")
          .doc(program.pid)
          .update({
        'programName': program.programName,
        'programDescription': program.programDescription,
        'programCreatedDate': Timestamp.now(),
      }); //insert sign up user record to firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }
}
