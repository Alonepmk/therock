import 'package:cloud_firestore/cloud_firestore.dart';

class Cms {
  String? cid;
  String? cmsName;
  String? cmsTitle;
  String? textColor;
  String? cmsPicLink;
  String? description;

  Cms({
    this.cid,
    this.cmsName,
    this.cmsTitle,
    this.textColor,
    this.cmsPicLink,
    this.description,
  });

  factory Cms.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Cms(
      cid: snap.id,
      cmsName: snapshot['cmsName'],
      cmsTitle: snapshot['cmsTitle'],
      //textColor: snapshot['textColor'],
      cmsPicLink: snapshot['cmsPicLink'],
      description: snapshot['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "cmsName": cmsName,
        "cmsTitle": cmsTitle,
        //"textColor": textColor,
        "cmsPicLink": cmsPicLink,
        "description": description,
      };
}
