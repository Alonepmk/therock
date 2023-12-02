import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/membership.dart';
import 'package:therock/models/program.dart';

class GymUserDBService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //initiate the firestore db instance
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //initiate firebase auth instance

  Future<String> createGymUser(GymUser user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'role': user.role,
        'isLogin': user.isLogin,
        'accountCreated': Timestamp.now(),
        'address': '',
        'currentMembershipId': '',
        'currentMembershipName': '',
        'currentProgramIndex': '0',
        'didCheckOutYesterday': 'no',
        'dob': '',
        'membershipEndDate': '',
        'membershipStartDate': '',
        'phoneNumber': '',
        'pid': '',
        'profilePicLink': '',
        'programCount': '0',
        'programName': '',
        'trainnerName': '',
        'trainnerUid': '',
        'uid': '',
      }); //insert sign up user record to firestore db
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  Future<GymUser> getUserInfo(String uid) async {
    GymUser retVal = GymUser();

    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection("users").doc(uid).get();
      debugPrint(docSnapshot.get("currentMembershipName"));
      retVal.uid = uid;
      retVal.email = docSnapshot.get("email");
      retVal.fullName = docSnapshot.get("fullName");
      retVal.accountCreated = docSnapshot.get("accountCreated");
      retVal.profilePicLink = docSnapshot.get("profilePicLink");
      retVal.phoneNumber = docSnapshot.get("phoneNumber");
      retVal.address = docSnapshot.get("address");
      retVal.dob = docSnapshot.get("dob");
      retVal.role = docSnapshot.get("role");
      retVal.trainnerUid = docSnapshot.get("trainnerUid");
      retVal.trainnerName = docSnapshot.get("trainnerName");
      retVal.currentMembershipName = docSnapshot.get("currentMembershipName");
      retVal.currentMembershipId = docSnapshot.get("currentMembershipId");
      retVal.membershipStartDate = docSnapshot.get("membershipStartDate");
      retVal.membershipEndDate = docSnapshot.get("membershipEndDate");
      retVal.pid = docSnapshot.get("pid");
      retVal.programName = docSnapshot.get("programName");
      retVal.programCount = docSnapshot.get("programCount");
      retVal.currentProgramIndex = docSnapshot.get("currentProgramIndex");
      retVal.didCheckOutYesterday = docSnapshot.get("didCheckOutYesterday");
      retVal.isLogin = docSnapshot.get("isLogin");

      debugPrint("in db ${retVal.isLogin}");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return retVal;
  }

  static Future updateUserInfo(GymUser user) async {
    await _firestore.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "fullName": user.fullName,
      "email": user.email,
      "accountCreated": user.accountCreated,
      "profilePicLink": user.profilePicLink,
      "address": user.address,
      "phoneNumber": user.phoneNumber,
      "dob": user.dob,
      "role": user.role,
      "trainnerUid": user.trainnerUid,
      "trainnerName": user.trainnerName,
      "pid": user.pid,
      "programName": user.programName,
      "isLogin": user.isLogin,
    }, SetOptions(merge: true));
  }

  static Future assignMembershipData(GymUser user) async {
    await _firestore.collection("users").doc(user.uid).set({
      "currentMembershipId": user.currentMembershipId,
      "currentMembershipName": user.currentMembershipName,
      "membershipStartDate": user.membershipStartDate,
      "membershipEndDate": user.membershipEndDate,
    }, SetOptions(merge: true));
  }

  static Future assignMembershipHistroy(
      GymUser user, String? membershipDescription) async {
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("membership_history")
        .doc()
        .set({
      "currentMembershipId": user.currentMembershipId,
      "currentMembershipName": user.currentMembershipName,
      "membershipStartDate": user.membershipStartDate,
      "membershipEndDate": user.membershipEndDate,
      "membershipDescription": membershipDescription,
    }, SetOptions(merge: true));
  }

  static Stream<List<Membership>> readMembershipHistory(String? uid) {
    final userCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("membership_history")
        .orderBy("membershipStartDate");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Membership.fromSnapshot(e)).toList());
  }

  Future updateUserLoginStatus(String? uid, String loginStatus) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .update({"isLogin": loginStatus});
  }

  static Future updateUser(GymUser? gymUser) async {
    await _firestore.collection("users").doc(gymUser!.uid).update(
      {
        "fullName": gymUser.fullName,
        "role": gymUser.role,
      },
    );
  }

  static Future deleteUser(String? uid) async {
    await _firestore.collection("users").doc(uid).delete();
  }

  static Future removeAllAttandanceRecord(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Attandance")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("Attandance")
              .doc(docSnapshot.id)
              .delete();
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Future removeAllMembershipHistoryRecord(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("membership_history")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("membership_history")
              .doc(docSnapshot.id)
              .delete();
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Future removeUserProgramRecord(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("user_program")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("user_program")
              .doc(docSnapshot.id)
              .delete();
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Future removeAllTrainne(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("trainnes")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("trainnes")
              .doc(docSnapshot.id)
              .delete();
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Stream<List<GymUser>> read() {
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.where('role', isNotEqualTo: "admin").snapshots().map(
        (querySnapshot) =>
            querySnapshot.docs.map((e) => GymUser.fromSnapshot(e)).toList());
  }

  Future<GymUser> getUserInfoByInitState() async {
    GymUser retVal = GymUser();

    try {
      User? firebaseUser =
          _auth.currentUser; // get user info from firebase auth
      String uid = firebaseUser!.uid;
      DocumentSnapshot docSnapshot =
          await _firestore.collection("users").doc(uid).get();

      retVal.uid = uid;
      retVal.email = docSnapshot.get("email");
      retVal.fullName = docSnapshot.get("fullName");
      retVal.accountCreated = docSnapshot.get("accountCreated");
      retVal.profilePicLink = docSnapshot.get("profilePicLink");
      retVal.phoneNumber = docSnapshot.get("phoneNumber");
      retVal.address = docSnapshot.get("address");
      retVal.dob = docSnapshot.get("dob");
      retVal.role = docSnapshot.get("role");
      retVal.trainnerUid = docSnapshot.get("trainnerUid");
      retVal.trainnerName = docSnapshot.get("trainnerName");
      retVal.currentMembershipName = docSnapshot.get("currentMembershipName");
      retVal.currentMembershipId = docSnapshot.get("currentMembershipId");
      retVal.membershipStartDate = docSnapshot.get("membershipStartDate");
      retVal.membershipEndDate = docSnapshot.get("membershipEndDate");
      retVal.pid = docSnapshot.get("pid");
      retVal.programName = docSnapshot.get("programName");
      retVal.programCount = docSnapshot.get("programCount");
      retVal.currentProgramIndex = docSnapshot.get("currentProgramIndex");
      retVal.didCheckOutYesterday = docSnapshot.get("didCheckOutYesterday");
      retVal.isLogin = docSnapshot.get("isLogin");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return retVal;
  }

  static Future<GymUser> getUserInfoByIdInitState(String? uid) async {
    GymUser retVal = GymUser();
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection("users").doc(uid).get();

      retVal.uid = uid;
      retVal.email = docSnapshot.get("email");
      retVal.fullName = docSnapshot.get("fullName");
      retVal.accountCreated = docSnapshot.get("accountCreated");
      retVal.profilePicLink = docSnapshot.get("profilePicLink");
      retVal.phoneNumber = docSnapshot.get("phoneNumber");
      retVal.address = docSnapshot.get("address");
      retVal.dob = docSnapshot.get("dob");
      retVal.role = docSnapshot.get("role");
      retVal.trainnerUid = docSnapshot.get("trainnerUid");
      retVal.trainnerName = docSnapshot.get("trainnerName");
      retVal.currentMembershipName = docSnapshot.get("currentMembershipName");
      retVal.currentMembershipId = docSnapshot.get("currentMembershipId");
      retVal.membershipStartDate = docSnapshot.get("membershipStartDate");
      retVal.membershipEndDate = docSnapshot.get("membershipEndDate");
      retVal.pid = docSnapshot.get("pid");
      retVal.programName = docSnapshot.get("programName");
      retVal.programCount = docSnapshot.get("programCount");
      retVal.currentProgramIndex = docSnapshot.get("currentProgramIndex");
      retVal.didCheckOutYesterday = docSnapshot.get("didCheckOutYesterday");
      retVal.isLogin = docSnapshot.get("isLogin");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return retVal;
  }

  static Stream<List<GymUser>> readTrainer() {
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.where('role', isEqualTo: "trainer").snapshots().map(
        (querySnapshot) =>
            querySnapshot.docs.map((e) => GymUser.fromSnapshot(e)).toList());
  }

  static Future assignTrainer(
      String? trainnerUid, String? uid, String trainnerName) async {
    await _firestore.collection("users").doc(uid).set(
        {"trainnerUid": trainnerUid, "trainnerName": trainnerName},
        SetOptions(merge: true));
  }

  static Future assignTrainne(GymUser? user, String? trainnerUid) async {
    await _firestore
        .collection("users")
        .doc(trainnerUid)
        .collection("trainnes")
        .doc(user!.uid)
        .set({
      "uid": user.uid,
      "fullName": user.fullName,
      "email": user.email,
      "phoneNumber": user.phoneNumber,
      "pid": user.pid,
      "programName": user.programName,
    }, SetOptions(merge: true));
  }

  static Future removeTrainne(String? uid, String? trainnerUid) async {
    await _firestore
        .collection("users")
        .doc(trainnerUid)
        .collection("trainnes")
        .doc(uid)
        .delete();
  }

  static Future removeTrainner(String? uid) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .set({"trainnerUid": "", "trainnerName": ""}, SetOptions(merge: true));
  }

  static Future emptyAccountData(String? uid) async {
    await _firestore.collection("users").doc(uid).set(
        {"accountCreated": "", "email": "", "role": "deleted"},
        SetOptions(merge: true));
  }

  static Future removeAllActivitiesFromUser(String? uid) async {
    // dangerous ********************************************
    // try {
    //   await _firestore
    //       .collection('users')
    //       .doc(uid)
    //       .collection("user_activities")
    //       .snapshots()
    //       .forEach((querySnapshot) {
    //     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
    //       docSnapshot.reference.delete(docSnapshot.id);
    //     }
    //   }).then((value) => _firestore.terminate());
    // } catch (e) {
    //   print(e.toString());
    // } finally {
    //   _firestore.terminate();
    // }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("activities")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("activities")
              .doc(docSnapshot.id)
              .delete();
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Stream<List<GymUser>> readTrainerTrainne(String? uid) {
    final userCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("trainnes");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => GymUser.fromSnapshot(e)).toList());
  }

  static Future addAllActivitiesToUser(String? pid, String? uid) async {
    //add all the activity from related program to sort the selectable list
    //print("the uid inside add all ${uid}");
    //print("the pid inside add all ${pid}");

    await FirebaseFirestore.instance
        .collection("programs")
        .doc(pid)
        .collection("activities")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var snapshot = docSnapshot.data();

          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("activities")
              .doc(docSnapshot.id)
              .set({
            "activityName": snapshot['activityName'],
            "videoLink": snapshot['videoLink'],
            "flag": false,
            "activityDescription": snapshot['activityDescription'],
            "activityCreatedDate": snapshot['activityCreatedDate']
          }, SetOptions(merge: true));
          //print("printing the activity Nameeee ${snapshot['activityName']}");
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Future addProgramReferenceToUser(String? pid, String? uid,
      String? programIndex, String? programName) async {
    //add all the activity from related program to sort the selectable list
    // print("the uid inside add all ${uid}");
    // print("the pid inside add all ${pid}");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("user_program")
        .doc(programIndex)
        .set({
      "memberProgramId": pid,
      "programName": programName,
    }, SetOptions(merge: true));
  }

  static Future updateUserProgramCount(String? uid, String programCount) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .update({"programCount": programCount});
  }

  static Future updateUserProgramIndex(
      String? uid, String programIndex, String? flagCheckOut) async {
    await _firestore.collection("users").doc(uid).update({
      "currentProgramIndex": programIndex,
      "didCheckOutYesterday": flagCheckOut
    });
  }

  static Stream<List<Program>> readUserRefProgram(String? uid) {
    final programCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("user_program");

    return programCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Program.fromSnapshot(e)).toList());
  }

  static Future removeUserProgramRef(String? pid, String? uid) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("user_program")
        .doc(pid)
        .delete()
        .then(
          (doc) => debugPrint("Document deleted"),
          onError: (e) => debugPrint("Error updating document $e"),
        );
  }

  static Future removeAllUserProgramRef(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("user_program")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("user_program")
              .doc(docSnapshot.id)
              .delete();
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  static Future<Program> readSpecificUserRefProgram(
      String? uid, String? refPid) async {
    Program returnProgram = Program();
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("user_program")
          .doc(refPid)
          .get();

      returnProgram.pid = docSnapshot.get("memberProgramId");
      returnProgram.programName = docSnapshot.get("programName");
      returnProgram.memberProgramId = docSnapshot.id;
    } catch (e) {
      debugPrint("error $e");
    }

    return returnProgram;
  }
}
