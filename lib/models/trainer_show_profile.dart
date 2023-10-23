import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerShowProfile {
  String? tid;
  String? nickName;
  String? contactEmail;
  String? contactNumber;
  String? bio;
  String? profileLink;
  String? showPicOne;
  String? showPicTwo;
  String? showPicThree;
  Timestamp? trainerProfileCreatedDate;

  TrainerShowProfile(
      {this.tid,
      this.nickName,
      this.contactEmail,
      this.contactNumber,
      this.bio,
      this.profileLink,
      this.showPicOne,
      this.showPicTwo,
      this.showPicThree,
      this.trainerProfileCreatedDate});

  factory TrainerShowProfile.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TrainerShowProfile(
      tid: snap.id,
      nickName: snapshot['nickName'],
      contactEmail: snapshot['contactEmail'],
      contactNumber: snapshot['contactNumber'],
      bio: snapshot['bio'],
      profileLink: snapshot['profileLink'],
      showPicOne: snapshot['showPicOne'],
      showPicTwo: snapshot['showPicTwo'],
      showPicThree: snapshot['showPicThree'],
      trainerProfileCreatedDate: snapshot['trainerProfileCreatedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "nickName": nickName,
        "contactEmail": contactEmail,
        "contactNumber": contactNumber,
        "bio": bio,
        "profileLink": profileLink,
        "showPicOne": showPicOne,
        "showPicTwo": showPicTwo,
        "showPicThree": showPicThree,
        "trainerProfileCreatedDate": trainerProfileCreatedDate,
      };
}
