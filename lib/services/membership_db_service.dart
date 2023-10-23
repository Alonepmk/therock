import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:therock/models/membership.dart';

class MembershipDBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String> createMembership(Membership membership) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance.collection("membership").doc().set(
        {
          'membershipType': membership.membershipType,
          'membershipDescription': membership.membershipDescription,
          'membershipCreatedDate': Timestamp.now(),
        },
        SetOptions(merge: true),
      ); //insert new membership record to firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  static Stream<List<Membership>> readMembership() {
    final membershipCollection = FirebaseFirestore.instance
        .collection("membership")
        .orderBy("membershipCreatedDate");

    return membershipCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Membership.fromSnapshot(e)).toList());
  }

  static Future<String> updateMembership(Membership membership) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance
          .collection("membership")
          .doc(membership.mid)
          .set(
        {
          'membershipType': membership.membershipType,
          'membershipDescription': membership.membershipDescription,
          'membershipCreatedDate': Timestamp.now(),
        },
        SetOptions(merge: true),
      ); //update Membership record in firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }
}
