import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/states/current_user.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

class CuViewAttandance extends StatefulWidget {
  const CuViewAttandance({super.key});

  @override
  State<CuViewAttandance> createState() => _CuViewAttandanceState();
}

class _CuViewAttandanceState extends State<CuViewAttandance> {
  double screenWidth = 0;
  double screenHeight = 0;

  String _month = DateFormat('MMMM').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: '#141414'.toColor(),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800.withOpacity(0.5),
          title: Row(
            children: [
              Align(
                child: FittedBox(
                  child: Text(
                    "Attandance",
                    style: TextStyle(
                      fontSize: screenWidth / 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 5),
                    child: FittedBox(
                      child: Text(
                        _month,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2099),
                          builder: (context, child) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SizedBox(
                                    height: 500,
                                    width: 900,
                                    child: child,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (month != null) {
                          setState(() {
                            _month = DateFormat('MMMM').format(month);
                          });
                        }
                      },
                      child: FittedBox(
                        child: FittedBox(
                          child: Text(
                            "Pick a Month",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser.getCurrentUser.uid)
                      .collection("Attandance")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return DateFormat('MMMM')
                                      .format(snap[index]['date'].toDate()) ==
                                  _month
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      top: 6, right: 10, bottom: 9),
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0,
                                            2), // shadow direction: bottom left
                                      )
                                    ],
                                    // borderRadius: BorderRadius.all(
                                    //   Radius.circular(20),
                                    // ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                            child: FittedBox(
                                              child: Text(
                                                DateFormat('EE\ndd').format(
                                                    snap[index]['date']
                                                        .toDate()),
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                "Check In",
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                snap[index]['checkIn'],
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                "Check Out",
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                snap[index]['checkOut'],
                                                style: TextStyle(
                                                  fontSize: screenWidth / 50,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox();
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
