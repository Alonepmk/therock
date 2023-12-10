import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  String? fid;
  String? currentMembershipName;
  Timestamp? createdDate;
  String? email;
  String? fullDate;
  String? fullName;
  String? hasTrainer;
  String? month;
  String? negative;
  String? other;
  String? positive;
  String? rating;
  String? service;
  String? trainer;
  String? uid;
  String? year;

  UserFeedback(
      {this.fid,
      this.currentMembershipName,
      this.createdDate,
      this.email,
      this.fullDate,
      this.fullName,
      this.hasTrainer,
      this.month,
      this.negative,
      this.other,
      this.positive,
      this.rating,
      this.service,
      this.trainer,
      this.uid,
      this.year});

  factory UserFeedback.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserFeedback(
      fid: snap.id,
      currentMembershipName: snapshot['currentMembershipName'],
      createdDate: snapshot['createdDate'],
      email: snapshot['email'],
      fullDate: snapshot['fullDate'],
      fullName: snapshot['fullName'],
      hasTrainer: snapshot['hasTrainer'],
      month: snapshot['month'],
      negative: snapshot['negative'],
      other: snapshot['other'],
      positive: snapshot['positive'],
      rating: snapshot['rating'],
      service: snapshot['service'],
      trainer: snapshot['trainer'],
      uid: snapshot['uid'],
      year: snapshot['year'],
    );
  }

  Map<String, dynamic> toJson() => {
        "fid": fid,
        "currentMembershipName": currentMembershipName,
        "createdDate": createdDate,
        "email": email,
        "fullDate": fullDate,
        "membershipType": fullName,
        "subject": hasTrainer,
        "message": month,
        "flag": negative,
        "other": other,
        "positive": positive,
        "rating": rating,
        "service": service,
        "trainer": trainer,
        "uid": uid,
        "year": year,
      };
}
