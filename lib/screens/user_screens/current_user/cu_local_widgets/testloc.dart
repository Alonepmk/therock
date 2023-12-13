import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:therock/screens/login/login.dart';
import 'package:therock/states/current_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Testloc extends StatefulWidget {
  const Testloc({super.key});

  @override
  State<Testloc> createState() => _TestlocState();
}

class _TestlocState extends State<Testloc> {
  var data = "hello";
  var test2 = "";
  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.deniedForever;

  @override
  void initState() {
    super.initState();
    //doCheckLocationOpen();
  }

  void doCheckLocationOpen() async {
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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    doCheckLocationOpen();
  }

  @override
  Widget build(BuildContext context) {
    if ((serviceEnabled) && (permission != LocationPermission.deniedForever)) {
      return SafeArea(
        child: Column(
          children: [
            Text(
                "Members Profiles cc ${context.watch<CurrentUser>().getCurrentBottomNavigationBarIndex}"),
            Center(
              child: ElevatedButton(
                  child: const Text("Sign Out"),
                  onPressed: () {
                    _signOut(context);
                  }),
            ),
            const SizedBox(height: 100),
            Text(
              "$data $test2",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 50),
            FloatingActionButton(
              onPressed: () {
                getPosition();
              },
              child: const Text("Get"),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: Column(
          children: [
            const Text(
              "Please Open Location service and press refresh to use the services",
              style: TextStyle(fontSize: 30),
            ),
            FloatingActionButton(
              onPressed: () {
                getPosition();
              },
              child: const Text("Get"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await currentUser.signOut();
    if (returnString == "success") {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
          (route) => false);
    }
  }

  void getPosition() async {
    var status = await Permission.location.request();
    //print("The status $status");
    if (status == PermissionStatus.granted) {
      Position datas = await _determindPosition();
      //print("The datas $datas");
      getAddressFromLatLong(datas);
    }
  }

  _determindPosition() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //print("The service Enable $serviceEnabled");
    if (!serviceEnabled) {
      setState(() {
        data = "Please open location to access the attandance system";
      });
      return Future.error("Location Service are disable");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error("location permission denied forever");
    }
    return await Geolocator.getLastKnownPosition();
  }

  void getAddressFromLatLong(Position datas) async {
    var datas = await Geolocator.getCurrentPosition();
    double startLatitude = 19.7048945;
    double startLongitude = 96.1313855;
    //print("i was here to test out things");
    List<Placemark> placemark =
        await placemarkFromCoordinates(datas.latitude, datas.longitude);
    print(" The latitude and Langitude ${datas.latitude}   ${datas.longitude}");
    double test = Geolocator.distanceBetween(
        startLatitude, startLongitude, datas.latitude, datas.longitude);

    test2 = "distance: ${(test * 3.28084).toStringAsFixed(0)} feet";
    print("distance: ${(test * 3.28084).toStringAsFixed(0)} feet ${test2} m");

    Placemark place = placemark[0];
    var address =
        "${place.street}, ${place.country}, ${datas.latitude}, ${datas.longitude}";
    setState(() {
      data = address;
    });
  }
}
