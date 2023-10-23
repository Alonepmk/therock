import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/models/membership.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/services/membership_db_service.dart';
import 'package:therock/states/current_user.dart';
import 'package:provider/provider.dart';

class CuViewMembership extends StatefulWidget {
  const CuViewMembership({super.key});

  @override
  State<CuViewMembership> createState() => _CuViewMembershipState();
}

class _CuViewMembershipState extends State<CuViewMembership> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    GymUser user = currentUser.getCurrentUser;
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        title: Row(
          children: [
            Align(
              child: Text(
                "Membership",
                style: TextStyle(
                  fontSize: screenWidth / 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Divider(
              //     color: Colors.white30,
              //   ),
              // ),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                margin: EdgeInsets.fromLTRB(
                    0, screenWidth / 40, screenWidth / 12, screenWidth / 65),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blueGrey.shade700,
                      Colors.blueGrey.shade300,
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2, 2), // shadow direction: bottom left
                    )
                  ],
                ),
                child: user.currentMembershipName != null &&
                        user.currentMembershipName != ""
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                " Active Membership ",
                                style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  // decorationColor: '#D9E7CB'.toColor(),
                                  // decorationThickness: 2,
                                  fontSize: screenWidth / 40,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: screenWidth / 15),
                                child: Icon(
                                  Icons.wallet_membership_sharp,
                                  size: screenWidth / 40,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "No Active Membership",
                          style: TextStyle(
                            fontSize: screenWidth / 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                margin: EdgeInsets.fromLTRB(0, 0, screenWidth / 12, 12),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 2), // shadow direction: bottom left
                    )
                  ],
                  color: Colors.grey.shade900,
                ),
                child: user.currentMembershipName != null &&
                        user.currentMembershipName != ""
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Membership Type",
                                  style: TextStyle(
                                    fontSize: screenWidth / 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${user.currentMembershipName}",
                                  style: TextStyle(
                                    fontSize: screenWidth / 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Start Date",
                                  style: TextStyle(
                                    fontSize: screenWidth / 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${user.membershipStartDate}",
                                  style: TextStyle(
                                    fontSize: screenWidth / 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "End Date",
                                  style: TextStyle(
                                    fontSize: screenWidth / 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${user.membershipEndDate}",
                                  style: TextStyle(
                                    fontSize: screenWidth / 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "No Active Membership",
                          style: TextStyle(
                            fontSize: screenWidth / 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),

              Container(
                width: screenWidth,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                margin: EdgeInsets.fromLTRB(screenWidth / 12, 12, 0, 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blueGrey.shade300,
                      Colors.blueGrey.shade700,
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 2), // shadow direction: bottom left
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "What we Offered! ",
                          style: TextStyle(
                            fontSize: screenWidth / 40,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenWidth / 10),
                          child: Icon(
                            Icons.stars_sharp,
                            size: screenWidth / 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                margin: EdgeInsets.fromLTRB(screenWidth / 12, 0, 0, 12),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2, 2), // shadow direction: bottom left
                    )
                  ],
                  color: Colors.grey.shade900,
                ),
                child: Column(
                  children: [
                    StreamBuilder<List<Membership>>(
                        stream: MembershipDBService.readMembership(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Some error occured"),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 8, 6, 0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '     ${snapshot.data![index].membershipType}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 40,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' - ${snapshot.data![index].membershipDescription}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 50,
                                                    color: Colors.white,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 2, 16, 0),
                                          child: Divider(
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ],
                ),
              ),
              Container(
                  width: screenWidth,
                  padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                  margin: EdgeInsets.fromLTRB(
                      0, screenWidth / 40, screenWidth / 12, screenWidth / 65),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blueGrey.shade700,
                        Colors.blueGrey.shade300,
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(2, 2), // shadow direction: bottom left
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            " Past Membership ",
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                              // decorationColor: '#D9E7CB'.toColor(),
                              // decorationThickness: 2,
                              fontSize: screenWidth / 40,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: screenWidth / 15),
                            child: Icon(
                              Icons.wallet_membership_sharp,
                              size: screenWidth / 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  )),
              Container(
                width: screenWidth,
                height: screenHeight / 1.8,
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                margin: EdgeInsets.fromLTRB(
                    0, 0, screenWidth / 12, screenWidth / 18),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2, 2), // shadow direction: bottom left
                    )
                  ],
                  color: Colors.grey.shade900,
                ),
                child: StreamBuilder<List<Membership>>(
                    stream: GymUserDBService.readMembershipHistory(
                        currentUser.getCurrentUser.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Some error occured"),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Membership Type",
                                            style: TextStyle(
                                              fontSize: screenWidth / 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data![index].currentMembershipName}",
                                            style: TextStyle(
                                              fontSize: screenWidth / 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Start Date",
                                            style: TextStyle(
                                              fontSize: screenWidth / 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data![index].membershipStartDate}",
                                            style: TextStyle(
                                              fontSize: screenWidth / 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "End Date",
                                            style: TextStyle(
                                              fontSize: screenWidth / 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data![index].membershipEndDate}",
                                            style: TextStyle(
                                              fontSize: screenWidth / 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 2, 16, 0),
                                      child: Divider(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
