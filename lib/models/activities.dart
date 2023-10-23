import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String? aid;
  String? activityName;
  String? activityDescription;
  String? videoLink;
  bool? flag;
  Timestamp? activityCreatedDate;

  Activity(
      {this.aid,
      this.activityName,
      this.activityDescription,
      this.videoLink,
      this.flag,
      this.activityCreatedDate});

  factory Activity.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Activity(
      aid: snap.id,
      activityName: snapshot['activityName'],
      activityDescription: snapshot['activityDescription'],
      videoLink: snapshot['videoLink'],
      flag: snapshot['flag'],
      activityCreatedDate: snapshot['activityCreatedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "activityName": activityName,
        "activityDescription": activityDescription,
        "videoLink": videoLink,
        "flag": flag,
        "activityCreatedDate": activityCreatedDate,
      };
}
