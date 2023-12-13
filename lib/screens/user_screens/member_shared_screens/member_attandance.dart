// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/gym_user_roles.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class MemberAttandance extends StatefulWidget {
  const MemberAttandance({super.key});

  @override
  State<MemberAttandance> createState() => _MemberAttandanceState();
}

class _MemberAttandanceState extends State<MemberAttandance> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";

  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.deniedForever;

  bool showFeedBackSection = true;
  double rating = 0.0;

  GymUser _user = GymUser();

  bool leaveComment = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _getRecord(); // to set it in the widget if the user already check in and out
    _initCupstate();
    _doCheckLocationOpen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _doCheckLocationOpen();
  }

  void _doCheckLocationOpen() async {
    var status = await Permission.location.request();
    //print("The status ${status}");
    if (status == PermissionStatus.granted) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      setState(() {
        serviceEnabled = serviceEnabled;
        permission = permission;
      });
    }
  }

  Future<void> _initCupstate() async {
    CurrentUser cu = Provider.of<CurrentUser>(context, listen: false);
    await GymUserDBService.getUserInfoByIdInitState(cu.getCurrentUser.uid).then(
      (value) {
        setState(() {
          _user = value;
        });
      },
    );
  }

  void _getRecord() async {
    try {
      CurrentUser cu = Provider.of<CurrentUser>(context, listen: false);
      _user = cu.getCurrentUser;

      //fetching check in & check out
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .collection("Attandance")
          .doc(DateFormat('dd MMMM yyyy')
              .format(DateTime.now())) // the d/m/y filter as doc id
          .get();

      //fetching showFeedBackSection
      DocumentSnapshot feedbackSnapShot = await FirebaseFirestore.instance
          .collection("feedback")
          .doc(DateFormat('ddMMMMyyyy').format(DateTime.now()) +
              _user.email.toString()) // the d/m/y filter as doc id
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];

        //check wether the feedback is given or not
        if (feedbackSnapShot.exists) {
          showFeedBackSection = false;
        } else {
          showFeedBackSection = true;
        }
      });
    } catch (e) {
      checkIn = "--/--";
      checkOut = "--/--";
      //showFeedBackSection = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    if ((serviceEnabled) && (permission != LocationPermission.deniedForever)) {
      if (_user.role == describeEnum(GymUserRole.currentUser) ||
          _user.role == describeEnum(GymUserRole.trainer)) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 1.5,
                  child: Text(
                    "Geo Attandance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 25,
                    ),
                  ),
                ),
                Container(
                  //check in container
                  margin: EdgeInsets.fromLTRB(0, screenWidth / 26, 30, 15),
                  height: screenHeight / 7,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(),
                          decoration: BoxDecoration(
                            //color: Colors.red.shade400,
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.blueGrey.shade300,
                                Colors.blueGrey.shade700,
                              ],
                            ),
                            // borderRadius: BorderRadius.all(
                            //   Radius.circular(20),
                            // ),
                          ),
                          child: Center(
                            child: Text(
                              'Check In',
                              style: TextStyle(
                                fontSize: screenWidth / 34,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              checkIn,
                              style: TextStyle(
                                fontSize: screenWidth / 36,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    DateFormat('dd MMMM yyyy').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: screenWidth / 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  //check out container
                  margin: const EdgeInsets.fromLTRB(30, 20, 0, 30),
                  height: screenHeight / 7,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(0, 2), // shadow direction: bottom left
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              checkOut,
                              style: TextStyle(
                                fontSize: screenWidth / 36,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.blueGrey.shade700,
                                Colors.blueGrey.shade300,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Check Out',
                              style: TextStyle(
                                fontSize: screenWidth / 34,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      screenWidth / 30, 0, screenWidth / 30, 0),
                  //height: screenHeight / 2,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0, // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          serviceEnabled
                              ? "Location Service is On"
                              : "Please Open Your Location Service",
                          style: TextStyle(
                            fontSize: screenWidth / 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          checkIn == '--/--'
                              ? "You haven't check In yet for today"
                              : "Successfully checked In",
                          style: TextStyle(
                            fontSize: screenWidth / 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          checkOut == '--/--'
                              ? "You haven't check Out yet for today"
                              : "Successfully checked Out",
                          style: TextStyle(
                            fontSize: screenWidth / 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      checkOut == "--/--"
                          ? Container(
                              margin: const EdgeInsets.all(16),
                              width: screenWidth / 2.1,
                              child: Builder(
                                builder: (context) {
                                  final GlobalKey<SlideActionState> key =
                                      GlobalKey();
                                  return SlideAction(
                                    borderRadius: 5,
                                    sliderButtonIconSize: 18,
                                    sliderButtonIconPadding: 10,
                                    text: checkIn == "--/--"
                                        ? "Slide to Check In"
                                        : "   Slide to Check Out",
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth / 35,
                                    ),
                                    outerColor: Colors.blueGrey.shade400,
                                    innerColor: Colors.grey.shade800,
                                    key: key,
                                    onSubmit: () async {
                                      showLoadingDialogUtil(context);
                                      serviceEnabled = await Geolocator
                                          .isLocationServiceEnabled();
                                      permission =
                                          await Geolocator.checkPermission();
                                      setState(() {
                                        serviceEnabled = serviceEnabled;
                                        permission = permission;
                                      });
                                      //print(serviceEnabled);
                                      //print(permission);

                                      if ((serviceEnabled) &&
                                          (permission !=
                                              LocationPermission
                                                  .deniedForever)) {
                                        // To check if the user is in the building
                                        //double startLatitude = 19.8047249;
                                        //double startLongitude = 96.1534415;
                                        double startLatitude = 19.7048945;
                                        double startLongitude = 96.1313855;

                                        var datas =
                                            await Geolocator.getCurrentPosition(
                                                desiredAccuracy:
                                                    LocationAccuracy.best);

                                        //print("the current position ${datas}");
                                        double distanceInmeter =
                                            Geolocator.distanceBetween(
                                                startLatitude,
                                                startLongitude,
                                                datas.latitude,
                                                datas.longitude);
                                        double distanceInfeet =
                                            distanceInmeter * 3.28084;

                                        //print("the distance in meter ${distanceInmeter}     ${distanceInfeet}");
                                        // end of calculation
                                        //if (distanceInfeet < 60) {
                                        if (distanceInfeet < 201) {
                                          Timer(const Duration(seconds: 1), () {
                                            key.currentState
                                                ?.reset(); // this recall the slider
                                          });

                                          if (checkIn == "--/--") {
                                            //Incrementing the current index if the user forget to check out yesterday
                                            if (int.parse(_user.programCount
                                                    .toString()) >
                                                0) {
                                              String currentProgramIndex;

                                              if (_user.didCheckOutYesterday
                                                      .toString() ==
                                                  "no") {
                                                if (_user.currentProgramIndex
                                                        .toString() ==
                                                    _user.programCount
                                                        .toString()) {
                                                  currentProgramIndex = "1";
                                                } else {
                                                  currentProgramIndex =
                                                      (int.parse(_user
                                                                  .currentProgramIndex
                                                                  .toString()) +
                                                              1)
                                                          .toString();
                                                }
                                              } else {
                                                currentProgramIndex = _user
                                                    .currentProgramIndex
                                                    .toString();
                                              }

                                              //print("the current program index at check in ${currentProgramIndex}");
                                              await GymUserDBService
                                                  .updateUserProgramIndex(
                                                      _user.uid,
                                                      currentProgramIndex,
                                                      "no");
                                            }
                                          } else {
                                            if (int.parse(_user.programCount
                                                    .toString()) >
                                                0) {
                                              String currentProgramIndex;

                                              if (_user.currentProgramIndex
                                                      .toString() ==
                                                  _user.programCount
                                                      .toString()) {
                                                currentProgramIndex = "1";
                                              } else {
                                                currentProgramIndex =
                                                    (int.parse(_user
                                                                .currentProgramIndex
                                                                .toString()) +
                                                            1)
                                                        .toString();
                                              }
                                              //print("the current program index at check out ${currentProgramIndex}");
                                              await GymUserDBService
                                                  .updateUserProgramIndex(
                                                      _user.uid,
                                                      currentProgramIndex,
                                                      "yes");
                                            }
                                          }
                                          Navigator.pop(context);

                                          ///end of incrementing program index

                                          DocumentSnapshot snap2 =
                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(_user.uid)
                                                  .collection("Attandance")
                                                  .doc(DateFormat(
                                                          'dd MMMM yyyy')
                                                      .format(DateTime.now()))
                                                  .get();

                                          try {
                                            String checkIn = snap2['checkIn'];

                                            setState(() {
                                              checkOut = DateFormat('hh:mm')
                                                  .format(DateTime.now());
                                            }); // this refresh the widget

                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(_user.uid)
                                                .collection("Attandance")
                                                .doc(DateFormat('dd MMMM yyyy')
                                                    .format(DateTime.now()))
                                                .update({
                                              'date': Timestamp.now(),
                                              'checkIn': checkIn,
                                              'checkOut': DateFormat('hh:mm')
                                                  .format(DateTime.now()),
                                            });

                                            //add inside the gym daily activity report
                                            await FirebaseFirestore.instance
                                                .collection("daily_activities")
                                                .doc(DateFormat('dd MMMM yyyy')
                                                    .format(DateTime.now()))
                                                .collection("Attandance")
                                                .doc(_user.uid)
                                                .set({
                                              'fullName': _user.fullName,
                                              'email': _user.email,
                                              'date': Timestamp.now(),
                                              'checkIn': checkIn,
                                              'checkOut': DateFormat('hh:mm')
                                                  .format(DateTime.now()),
                                            }, SetOptions(merge: true));
                                          } catch (e) {
                                            setState(() {
                                              checkIn = DateFormat('hh:mm')
                                                  .format(DateTime.now());
                                            }); // this refresh the widget
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(_user.uid)
                                                .collection("Attandance")
                                                .doc(DateFormat('dd MMMM yyyy')
                                                    .format(DateTime.now()))
                                                .set({
                                              'date': Timestamp.now(),
                                              'checkIn': DateFormat('hh:mm')
                                                  .format(DateTime.now()),
                                              'checkOut': "--/--",
                                            });

                                            ///add inside the gym daily report collection
                                            await FirebaseFirestore.instance
                                                .collection("daily_activities")
                                                .doc(DateFormat('dd MMMM yyyy')
                                                    .format(DateTime.now()))
                                                .collection("Attandance")
                                                .doc(_user.uid)
                                                .set({
                                              'fullName': _user.fullName,
                                              'email': _user.email,
                                              'date': Timestamp.now(),
                                              'checkIn': DateFormat('hh:mm')
                                                  .format(DateTime.now()),
                                              'checkOut': "--/--",
                                            }, SetOptions(merge: true));
                                          }
                                        } else {
                                          scaffoldUtil(
                                              context,
                                              "You are Not in the range of gym building",
                                              3);
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    }, // end of on Submit Slider
                                  );
                                },
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: showFeedBackSection == true
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "How was your Experience Today",
                                          style: TextStyle(
                                            fontSize: screenWidth / 50,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.mood,
                                              ),
                                              iconSize: screenWidth / 18,
                                              color: Colors.grey.shade400,
                                              onPressed: () {
                                                showPositiveFeedBackDialog();
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.mood_bad_sharp,
                                              ),
                                              iconSize: screenWidth / 18,
                                              color: Colors.grey.shade400,
                                              splashColor: Colors.purple,
                                              onPressed: () {
                                                showNegativeFeedBackDialog();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        "Thanks For Your Feedback",
                                        style: TextStyle(
                                          fontSize: screenWidth / 50,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_disabled_outlined,
                  size: screenWidth / 10,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 10),
                Text(
                  "Access Denied!",
                  style: TextStyle(
                    fontSize: screenWidth / 30,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(
              screenWidth / 20, screenHeight / 3, screenWidth / 20, 0),
          child: Column(
            children: [
              Text(
                "Please Open Location service or give access and then press refresh to use the services",
                style: TextStyle(
                  fontSize: screenWidth / 50,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FloatingActionButton.extended(
                      heroTag: "member_attandance_permission",
                      onPressed: () {
                        openAppSettings();
                      },
                      label: const Text('Permission'),
                      icon: const Icon(Icons.location_on_outlined),
                      backgroundColor: Colors.blueGrey.shade400,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: FloatingActionButton.extended(
                      heroTag: "member_attandance_refresh_button",
                      onPressed: () {
                        _doCheckLocationOpen();
                      },
                      label: const Text('Refresh'),
                      icon: const Icon(Icons.refresh_sharp),
                      backgroundColor: Colors.blueGrey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildRating() => RatingBar.builder(
        minRating: 1,
        itemSize: 40,
        itemBuilder: (context, _) => const Icon(Icons.star),
        onRatingUpdate: (rating) {
          setState(() {
            this.rating = rating;
          });
        },
      );

  void showPositiveFeedBackDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Rate Us'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                buildRating(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (rating > 0) {
                  showLoadingDialogUtil(context);
                  String theId =
                      DateFormat('ddMMMMyyyy').format(DateTime.now()) +
                          _user.email.toString();
                  await FirebaseFirestore.instance
                      .collection("feedback")
                      .doc(theId)
                      .set({
                    'positive': "true",
                    'negative': "false",
                    'rating': rating.toString(),
                    'trainer': "",
                    'service': "",
                    'other': "",
                    'uid': _user.uid,
                    'email': _user.email,
                    'fullName': _user.fullName,
                    'currentMembershipName': _user.currentMembershipName,
                    'hasTrainer': _user.trainnerName,
                    'createdDate': DateTime.now(),
                    'fullDate':
                        DateFormat('dd MMMM yyyy').format(DateTime.now()),
                    'month': DateFormat('MMMM').format(DateTime.now()),
                    'year': DateFormat('yyyy').format(DateTime.now()),
                  });
                  setState(() {
                    showFeedBackSection = false;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void showNegativeFeedBackDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: SingleChildScrollView(
            child: Row(
              children: [
                const Expanded(
                    child: Text("Leave a Comment about Your Experience")),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showNegativeFeedBackTextDialog();
                  },
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showNegativeFeedBackTextDialog() {
    showDialog(
      context: context,
      builder: (_) {
        var serviceControlller = TextEditingController();
        var trainerController = TextEditingController();
        var otherController = TextEditingController();

        return AlertDialog(
          title: const Text('Feedback'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: serviceControlller,
                  decoration: const InputDecoration(
                    hintText: 'Service',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
                TextFormField(
                  controller: trainerController,
                  decoration: const InputDecoration(
                    hintText: 'Trainer',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
                TextFormField(
                  controller: otherController,
                  decoration: const InputDecoration(
                    hintText: 'Others',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var service = serviceControlller.text;
                var trainer = trainerController.text;
                var others = otherController.text;

                if (service.isNotEmpty ||
                    trainer.isNotEmpty ||
                    others.isNotEmpty) {
                  showLoadingDialogUtil(context);
                  String theId =
                      DateFormat('ddMMMMyyyy').format(DateTime.now()) +
                          _user.email.toString();
                  await FirebaseFirestore.instance
                      .collection("feedback")
                      .doc(theId)
                      .set({
                    'positive': "false",
                    'negative': "true",
                    'rating': "",
                    'trainer': trainer,
                    'service': service,
                    'other': others,
                    'uid': _user.uid,
                    'email': _user.email,
                    'fullName': _user.fullName,
                    'currentMembershipName': _user.currentMembershipName,
                    'hasTrainer': _user.trainnerName,
                    'createdDate': DateTime.now(),
                    'fullDate':
                        DateFormat('dd MMMM yyyy').format(DateTime.now()),
                    'month': DateFormat('MMMM').format(DateTime.now()),
                    'year': DateFormat('yyyy').format(DateTime.now()),
                  });
                  setState(() {
                    showFeedBackSection = false;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
