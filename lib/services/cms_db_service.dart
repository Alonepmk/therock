import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:therock/models/cms.dart';

class CmsDBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<List<Cms>> readCmsList() {
    final membershipCollection = FirebaseFirestore.instance.collection("cms");

    return membershipCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Cms.fromSnapshot(e)).toList());
  }

  static Future<void> updateCms(Cms cms) async {
    try {
      await FirebaseFirestore.instance.collection("cms").doc(cms.cid).update({
        'cmsName': cms.cmsName,
        'cmsTitle': cms.cmsTitle,
        'description': cms.description,
        'cmsPicLink': cms.cmsPicLink,
      }); //update activity record in firestore db
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
