import 'package:cloud_firestore/cloud_firestore.dart';

class Program {
  String? pid;
  String? programName;
  String? programDescription;
  String? memberProgramId;
  Timestamp? programCreatedDate;

  Program({
    this.pid,
    this.programName,
    this.programDescription,
    this.memberProgramId,
    this.programCreatedDate,
  });

  factory Program.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Program(
      pid: snap.id,
      programName: snapshot['programName'],
      programDescription: snapshot['programDescription'],
      memberProgramId: snapshot['memberProgramId'],
      programCreatedDate: snapshot['programCreatedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "programName": programName,
        "programDescription": programDescription,
        "memberProgramId": memberProgramId,
        "programCreatedDate": programCreatedDate,
      };
}
