import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:therock/models/feedback.dart';
import 'package:therock/models/program.dart';

class FeedbackDBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<UserFeedback>> readFeedbackByParam(
      String paramField, String paramSearch) {
    final userCollection = FirebaseFirestore.instance.collection("feedback");
    return userCollection
        .where(paramField, isEqualTo: paramSearch)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((DocumentSnapshot doc) => UserFeedback.fromSnapshot(doc))
          .toList();
    });
  }

  static Future<List<UserFeedback>> readFeedbackByTwoParam(String paramFieldOne,
      String paramFieldTwo, String paramSearchOne, String paramSearchTwo) {
    final userCollection = FirebaseFirestore.instance.collection("feedback");
    return userCollection
        .where(paramFieldOne, isEqualTo: paramSearchOne)
        .where(paramFieldTwo, isEqualTo: paramSearchTwo)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((DocumentSnapshot doc) => UserFeedback.fromSnapshot(doc))
          .toList();
    });
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
