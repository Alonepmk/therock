import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/states/current_user.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

class CuBmr extends StatefulWidget {
  const CuBmr({super.key});

  @override
  State<CuBmr> createState() => _CuBmrState();
}

class _CuBmrState extends State<CuBmr> {
  double screenWidth = 0;
  double screenHeight = 0;

  String date = "";
  String bmrPicLink = "";
  String lastAcquiredDate = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                    "B M R",
                    style: TextStyle(
                      fontSize: screenWidth / 22,
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
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(3000),
                      builder: (context, child) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: screenHeight / 1.3,
                                width: screenWidth,
                                child: child,
                              ),
                            ),
                          ],
                        );
                      },
                    ).then((value) async {
                      if (value != null) {
                        setState(() {
                          date = DateFormat('MMMM yyyy').format(value);
                        });

                        DocumentSnapshot snap = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser.getCurrentUser.uid)
                            .collection("user_bmr")
                            .doc(date)
                            .get();
                        if (snap.data() != null) {
                          setState(() {
                            bmrPicLink = snap["bmrPicLink"];
                          });
                        } else {
                          setState(() {
                            bmrPicLink = "";
                          });
                        }
                      }
                    });
                  },
                  child: FittedBox(
                    alignment: Alignment.center,
                    child: Text(
                      "Pick a Month",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 22,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              bmrPicLink != ""
                  ? SizedBox(
                      child: Text(
                        '"Below is your BMR Record For $date"',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20.0),
              bmrPicLink != ""
                  ? Container(
                      width: double.infinity,
                      height: screenHeight / 1.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: bmrPicLink,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Icon(
                          Icons.unpublished_rounded,
                          color: Colors.white,
                          size: screenWidth / 3,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          child: Text(
                            "No BMR Record for $date",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth / 25),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
