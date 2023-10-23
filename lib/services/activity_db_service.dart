import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:therock/models/activities.dart';

class ActivityDBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String> createActivity(Activity activity, String pid) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance
          .collection("programs")
          .doc(pid)
          .collection("activities")
          .doc()
          .set({
        'activityName': activity.activityName,
        'activityDescription': activity.activityDescription,
        'videoLink': activity.videoLink,
        'flag': false,
        'activityCreatedDate': Timestamp.now(),
      }); //insert activity record to firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  static Stream<List<Activity>> read(String? pid) {
    final programCollection = FirebaseFirestore.instance
        .collection("programs")
        .doc(pid)
        .collection("activities")
        .orderBy("activityName");

    return programCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Activity.fromSnapshot(e)).toList());
  }

  static Future<String> updateActivity(Activity activity, String pid) async {
    String retVal = "error";
    try {
      await FirebaseFirestore.instance
          .collection("programs")
          .doc(pid)
          .collection("activities")
          .doc(activity.aid)
          .update({
        'activityName': activity.activityName,
        'activityDescription': activity.activityDescription,
        'videoLink': activity.videoLink,
        'flag': false,
        'activityCreatedDate': Timestamp.now(),
      }); //update activity record in firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  static Stream<List<Activity>> readByGymUser(String? uid) {
    final programCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("activities")
        .where('flag', isEqualTo: true);

    return programCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Activity.fromSnapshot(e)).toList());
  }

  static Stream<List<Activity>> readByDay(String? pid) {
    final programCollection = FirebaseFirestore.instance
        .collection("programs")
        .doc(pid)
        .collection("activities");

    return programCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Activity.fromSnapshot(e)).toList());
  }
}
