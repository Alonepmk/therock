import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/trainer_show_profile.dart';
import 'package:therock/screens/user_screens/member_shared_screens/view_trainer/member_view_trainer_detail.dart';

class ViewTrainer extends StatefulWidget {
  const ViewTrainer({super.key});

  @override
  State<ViewTrainer> createState() => _ViewTrainerState();
}

class _ViewTrainerState extends State<ViewTrainer> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: '#141414'.toColor(),
        appBar: AppBar(
          elevation: 20,
          backgroundColor: Colors.grey.shade800.withOpacity(0.5),
          title: Row(
            children: [
              Align(
                child: FittedBox(
                  child: Text(
                    "Our Trainers",
                    style: TextStyle(
                      fontSize: screenHeight / 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              const SizedBox(height: 6.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("trainer_show_profile")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return GridView.builder(
                        itemCount: snap.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: screenWidth < 450 ? 2 : 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              TrainerShowProfile tsp = TrainerShowProfile(
                                nickName: snap[index]['nickName'],
                                contactEmail: snap[index]['contactEmail'],
                                contactNumber: snap[index]['contactNumber'],
                                bio: snap[index]['bio'],
                                profileLink: snap[index]['profileLink'],
                                showPicOne: snap[index]['showPicOne'],
                                showPicTwo: snap[index]['showPicTwo'],
                                showPicThree: snap[index]['showPicThree'],
                              );
                              Get.to(() => ViewTrainerDetail(tsp: tsp));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    height: screenWidth < 450
                                        ? screenHeight / 6
                                        : screenHeight / 7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: snap[index]['profileLink'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: screenWidth < 450
                                                ? screenWidth / 4
                                                : screenWidth / 5,
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              // image: DecorationImage(
                                              //   image: imageProvider,
                                              //   fit: BoxFit.fill,
                                              // ),
                                              shape: BoxShape.circle,
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.brown,
                                                    blurRadius: 5.0,
                                                    offset: Offset(0.0, 0.75))
                                              ],
                                              color: Colors.tealAccent,
                                            ),
                                            child: CircleAvatar(
                                              radius: screenWidth / 9,
                                              backgroundImage: imageProvider,
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0.0),
                                    child: FittedBox(
                                      child: Text(
                                        snap[index]['nickName'],
                                        style: TextStyle(
                                          fontSize: screenWidth / 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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
