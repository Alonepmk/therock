import 'package:flutter/material.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/login/login.dart';
import 'package:therock/screens/user_screens/admin/admin_home.dart';
import 'package:therock/screens/user_screens/current_user/current_user_home.dart';
import 'package:therock/screens/user_screens/guest/guest_home.dart';
import 'package:therock/screens/user_screens/past_user/past_user_home.dart';
import 'package:therock/screens/user_screens/receptionist/receptionist_home.dart';
import 'package:therock/screens/user_screens/trainer/trainer_home.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  notLoggedIn,
  loggedIn,
  temp,
}

class OurRoot extends StatefulWidget {
  const OurRoot({super.key});

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  double screenWidth = 0;
  double screenHeight = 0;

  AuthStatus _authStatus = AuthStatus.temp;

  GymUser hasUser = GymUser();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    hasUser = await currentUser.onStartUp();

    if (hasUser.uid != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    return FutureBuilder(
      future: currentUser.onStartUp(),
      builder: (BuildContext context, AsyncSnapshot<GymUser> hasUser) {
        if (mounted) {
          screenHeight = MediaQuery.of(context).size.height;
          screenWidth = MediaQuery.of(context).size.height;
        }
        Widget retVal = Container();
        if (hasUser.connectionState == ConnectionState.done) {
          if ((_authStatus == AuthStatus.loggedIn) &&
              (hasUser.data!.role == "admin")) {
            retVal = const AdminHome();
          } else if ((_authStatus == AuthStatus.loggedIn) &&
              (hasUser.data!.role == "trainer")) {
            retVal = const TrainerHome();
          } else if ((_authStatus == AuthStatus.loggedIn) &&
              (hasUser.data!.role == "currentUser")) {
            retVal = const CurrentUserHome();
          } else if ((_authStatus == AuthStatus.loggedIn) &&
              (hasUser.data!.role == "pastUser")) {
            retVal = const PastUserHome();
          } else if ((_authStatus == AuthStatus.loggedIn) &&
              (hasUser.data!.role == "guest")) {
            retVal = const GuestHome();
          } else if ((_authStatus == AuthStatus.loggedIn) &&
              (hasUser.data!.role == "receptionist")) {
            retVal = const ReceptionistHome();
          } else {
            retVal = const Login(); //_authStatus == AuthStatus.notLoggedIn
          }
          return retVal;
        } else {
          return SizedBox(
            width: 400,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "Hi ${currentUser.getCurrentUser.fullName}, Your App is Initializing",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 60,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  backgroundColor: Colors.blueGrey,
                  color: Colors.white,
                  strokeCap: StrokeCap.round,
                ),
              ],
            ),
          );
        }
      },
    );

    //This was the previous Auth determiner // had some error
    // Widget retVal = Container();
    // print("was here and ${_authStatus}");
    // if ((_authStatus == AuthStatus.loggedIn) && (hasUser.role == "admin")) {
    //   retVal = const AdminHome();
    // } else if ((_authStatus == AuthStatus.loggedIn) &&
    //     (hasUser.role == "trainer")) {
    //   retVal = const TrainerHome();
    // } else if ((_authStatus == AuthStatus.loggedIn) &&
    //     (hasUser.role == "currentUser")) {
    //   retVal = const CurrentUserHome();
    // } else if ((_authStatus == AuthStatus.loggedIn) &&
    //     (hasUser.role == "pastUser")) {
    //   retVal = const PastUserHome();
    // } else if ((_authStatus == AuthStatus.loggedIn) &&
    //     (hasUser.role == "guest")) {
    //   retVal = const GuestHome();
    // } else {
    //   retVal = const Login(); //_authStatus == AuthStatus.notLoggedIn
    // }
    // return retVal;
  }
}
