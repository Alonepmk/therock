import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/gym_user_login_status.dart';
import 'package:therock/models/gym_user_roles.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/screens/user_screens/admin/admin_home.dart';
import 'package:therock/screens/user_screens/current_user/current_user_home.dart';
import 'package:therock/screens/user_screens/guest/guest_home.dart';
import 'package:therock/screens/user_screens/past_user/past_user_home.dart';
import 'package:therock/screens/user_screens/trainer/trainer_home.dart';
import 'package:therock/services/gym_user_db_service.dart';

class CurrentUser extends ChangeNotifier {
  GymUser _currentUser =
      GymUser(); // for the storage of user info throughout the login app state

  ReturnDataString rds = ReturnDataString();

  Widget userHomeWidget = Container(); // for the User Home Page Navigation Bar
  int _currentBottomNavigationBarIndex = 0;

  GymUser get getCurrentUser => _currentUser; // return the GymUser Model

  ReturnDataString get getReturnDataString => rds;

  Widget get getUserHomeWidget => userHomeWidget; // return the _userHomeWidget

  int get getCurrentBottomNavigationBarIndex =>
      _currentBottomNavigationBarIndex; // return the _currentBottomNavigationBarIndex

  Future<void> setCurrentBottomNavigationBarIndex(int index) async {
    _currentBottomNavigationBarIndex =
        index; // set the _currentBottomNavigationBarIndex
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance; //Initiate Firebase Instance

  Future<ReturnDataString> signUpUser(
      String email, String password, String fullName) async {
    ReturnDataString rds = ReturnDataString();
    rds.status = "error";
    GymUser user =
        GymUser(); //build an instance of gym user model for data storage

    try {
      print("inside of sign up");
      UserCredential signUpAuthResult = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      user.uid = signUpAuthResult.user!.uid;
      user.email = signUpAuthResult.user!.email;
      user.fullName = fullName;
      user.isLogin = describeEnum(GymUserLoginStatus.isNotLoggedIn);
      user.role = describeEnum(GymUserRole.guest);

      String returnString = await GymUserDBService().createGymUser(user);
      if (returnString == "success") {
        rds.status = "success";
        rds.message = "Successfully Sign Up";
      }
    } catch (e) {
      rds.message = e.toString();
    }

    return rds;
  }

  Future<ReturnDataString> loginUserWithEmail(
      String email, String password) async {
    ReturnDataString rds = ReturnDataString();
    rds.gymUser = GymUser();
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _currentUser = await GymUserDBService().getUserInfo(authResult.user!.uid);

      if ((_currentUser.uid != null) &&
          (_currentUser.isLogin == "isNotLoggedIn")) {
        rds.status = "success";
        rds.gymUser?.role = _currentUser.role;
        await GymUserDBService().updateUserLoginStatus(
            _currentUser.uid,
            describeEnum(GymUserLoginStatus
                .isLoggedIn)); // Change the login status of user to prevent multiple device login
        //   print("Hello123 ${_currentUser.role}");
      } else {
        rds.status = "error";
        rds.message = "User Already Sign In On Other Devices";
        //   print("Hello ${rds.message}");
      }
    } catch (e) {
      rds.message = e.toString();
    }

    return rds;
  }

  Future<String> signOut() async {
    String retVal = "error";
    try {
      await GymUserDBService().updateUserLoginStatus(
          _currentUser.uid,
          describeEnum(GymUserLoginStatus
              .isNotLoggedIn)); // Change the login status of user to prevent multiple device login
      //   print("Hello123 ${_currentUser.role}");
      await _auth.signOut();
      _currentUser = GymUser();
      _currentBottomNavigationBarIndex = 0;
      retVal = "success";
    } catch (e) {
      debugPrint("error $e");
    }
    return retVal;
  }

  Future<GymUser> onStartUp() async {
    GymUser retVal = GymUser();
    try {
      User? firebaseUser =
          _auth.currentUser; // get user info from firebase auth
      _currentUser = await GymUserDBService().getUserInfo(firebaseUser!
          .uid); // get user data from firestore db : collection "users"
      if (_currentUser.uid != null) {
        getGymUserHomeWidget(_currentUser.role!);
        retVal = _currentUser;
      }
    } catch (e) {
      debugPrint("error $e");
    }
    return retVal;
  }

  void getGymUserHomeWidget(String role) {
    if (role == "admin") {
      userHomeWidget = const AdminHome();
    }
    if (role == "trainer") {
      userHomeWidget = const TrainerHome();
    }
    if (role == "currentUser") {
      userHomeWidget = const CurrentUserHome();
    }
    if (role == "pastUser") {
      userHomeWidget = const PastUserHome();
    }
    if (role == "guest") {
      userHomeWidget = const GuestHome();
    }
  }
}
