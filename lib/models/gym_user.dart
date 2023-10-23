import 'package:cloud_firestore/cloud_firestore.dart';

class GymUser {
  String? uid;
  String? email;
  String? fullName;
  String? role;
  String? isLogin;
  String? address;
  String? phoneNumber;
  String? profilePicLink;
  String? dob;
  String? trainnerUid;
  String? trainnerName;
  String? pid;
  String? programName;
  String? currentMembershipId;
  String? currentMembershipName;
  String? membershipStartDate;
  String? membershipEndDate;
  String? programCount;
  String? currentProgramIndex;
  String? didCheckOutYesterday;
  bool? hasCurrentMembership;
  Timestamp? accountCreated;

  GymUser({
    this.uid,
    this.email,
    this.fullName,
    this.role,
    this.isLogin,
    this.address,
    this.phoneNumber,
    this.profilePicLink,
    this.dob,
    this.trainnerUid,
    this.trainnerName,
    this.pid,
    this.programName,
    this.currentMembershipId,
    this.currentMembershipName,
    this.hasCurrentMembership,
    this.membershipStartDate,
    this.membershipEndDate,
    this.programCount,
    this.currentProgramIndex,
    this.didCheckOutYesterday,
    this.accountCreated,
  });

  factory GymUser.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return GymUser(
      uid: snap.id,
      email: snapshot['email'],
      fullName: snapshot['fullName'],
      address: snapshot['address'],
      phoneNumber: snapshot['phoneNumber'],
      profilePicLink: snapshot['profilePicLink'],
      dob: snapshot['dob'],
      role: snapshot['role'],
      trainnerUid: snapshot['trainnerUid'],
      trainnerName: snapshot['trainnerName'],
      pid: snapshot['pid'],
      programName: snapshot['programName'],
      currentMembershipId: snapshot['currentMembershipId'],
      currentMembershipName: snapshot['currentMembershipName'],
      hasCurrentMembership: snapshot['hasCurrentMembership'],
      membershipStartDate: snapshot['membershipStartDate'],
      membershipEndDate: snapshot['membershipEndDate'],
      programCount: snapshot['programCount'],
      currentProgramIndex: snapshot['currentProgramIndex'],
      didCheckOutYesterday: snapshot['didCheckOutYesterday'],
      isLogin: snapshot['isLogin'],
      accountCreated: snapshot['accountCreated'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "fullName": fullName,
        "address": address,
        "phoneNumber": phoneNumber,
        "profilePicLink": profilePicLink,
        "dob": dob,
        "role": role,
        "trainnerUid": trainnerUid,
        "trainnerName": trainnerName,
        "pid": pid,
        "programName": programName,
        "currentMembershipId": currentMembershipId,
        "currentMembershipName": currentMembershipName,
        "hasCurrentMembership": hasCurrentMembership,
        "membershipStartDate": membershipStartDate,
        "membershipEndDate": membershipEndDate,
        "programCount": programCount,
        "currentProgramIndex": currentProgramIndex,
        "didCheckOutYesterday": didCheckOutYesterday,
        "isLogin": isLogin,
        "accountCreated": accountCreated
      };
}
