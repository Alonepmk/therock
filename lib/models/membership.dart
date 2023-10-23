import 'package:cloud_firestore/cloud_firestore.dart';

class Membership {
  String? mid;
  String? membershipType;
  String? currentMembershipName;
  String? membershipStartDate;
  String? membershipEndDate;
  String? membershipDescription;
  Timestamp? membershipCreatedDate;

  Membership(
      {this.mid,
      this.membershipType,
      this.currentMembershipName,
      this.membershipStartDate,
      this.membershipEndDate,
      this.membershipDescription,
      this.membershipCreatedDate});

  factory Membership.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Membership(
      mid: snap.id,
      membershipType: snapshot['membershipType'],
      currentMembershipName: snapshot['currentMembershipName'],
      membershipStartDate: snapshot['membershipStartDate'],
      membershipEndDate: snapshot['membershipEndDate'],
      membershipDescription: snapshot['membershipDescription'],
      membershipCreatedDate: snapshot['membershipCreatedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "membershipType": membershipType,
        "currentMembershipName": currentMembershipName,
        "membershipStartDate": membershipStartDate,
        "membershipEndDate": membershipEndDate,
        "membershipDescription": membershipDescription,
        "membershipCreatedDate": membershipCreatedDate,
      };
}
