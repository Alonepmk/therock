import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  String? fid;
  String? uid;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? membershipType;
  String? subject;
  String? message;
  String? flag;
  Timestamp? feedBackCreatedDate;

  Feedback(
      {this.fid,
      this.uid,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.membershipType,
      this.subject,
      this.message,
      this.flag,
      this.feedBackCreatedDate});

  factory Feedback.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Feedback(
      fid: snap.id,
      uid: snapshot['uid'],
      fullName: snapshot['fullName'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
      membershipType: snapshot['membershipType'],
      subject: snapshot['subject'],
      message: snapshot['message'],
      flag: snapshot['flag'],
      feedBackCreatedDate: snapshot['feedBackCreatedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "fid": fid,
        "uid": uid,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "membershipType": membershipType,
        "subject": subject,
        "message": message,
        "flag": flag,
        "feedBackCreatedDate": feedBackCreatedDate,
      };
}
