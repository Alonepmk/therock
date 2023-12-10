// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:therock/models/feedback.dart';
import 'package:therock/services/feedback_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class ManageFeedBack extends StatefulWidget {
  const ManageFeedBack({super.key});

  @override
  State<ManageFeedBack> createState() => _ManageFeedBackState();
}

class _ManageFeedBackState extends State<ManageFeedBack> {
  double screenWidth = 0;
  double screenHeight = 0;

  String filterName = "";
  String filterEmail = "";

  String filterType = "";
  String date = "";

  List<UserFeedback> searchResult = [];
  TextEditingController paramTextBoxController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    //filterData = myData;
    //print(myData.toList());
    super.initState();
  }

  void doSearchAndInitFeedBack(String param) async {
    showLoadingDialogUtil(context);
    List<UserFeedback> tempResult = [];
    // if (filterType == "name") {
    //   tempResult = await GymUserDBService.readUserByName(param);
    // } else if (filterType == "email") {
    //   tempResult = await GymUserDBService.readUserByEmail(param);
    // } else {
    //   tempResult = await GymUserDBService.readUserByPhone(param);
    // }
    if (filterType == "name") {
      tempResult =
          await FeedbackDBService.readFeedbackByParam("fullName", param);
    } else if (filterType == "email") {
      tempResult = await FeedbackDBService.readFeedbackByParam("email", param);
    } else if (filterType == "trainer") {
      tempResult =
          await FeedbackDBService.readFeedbackByParam("hasTrainer", param);
    } else if (filterType == "membership") {
      tempResult = await FeedbackDBService.readFeedbackByParam(
          "currentMembershipName", param);
    } else if (filterType == "rating") {
      tempResult = await FeedbackDBService.readFeedbackByParam("rating", param);
    } else if (filterType == "positive") {
      tempResult =
          await FeedbackDBService.readFeedbackByParam("positive", param);
    } else if (filterType == "negative") {
      tempResult =
          await FeedbackDBService.readFeedbackByParam("negative", param);
    } else if (filterType == "month") {
      tempResult = await FeedbackDBService.readFeedbackByParam("month", date);
    } else if (filterType == "year") {
      tempResult = await FeedbackDBService.readFeedbackByParam("year", date);
    } else if (filterType == "fullDate") {
      tempResult =
          await FeedbackDBService.readFeedbackByParam("fullDate", date);
    } else if (filterType == "ratingandmonth") {
      tempResult = await FeedbackDBService.readFeedbackByTwoParam(
          "rating", "month", param, date);
    } else if (filterType == "ratingandyear") {
      tempResult = await FeedbackDBService.readFeedbackByTwoParam(
          "rating", "year", param, date);
    } else if (filterType == "positiveandmonth") {
      tempResult = await FeedbackDBService.readFeedbackByTwoParam(
          "positive", "month", param, date);
    } else if (filterType == "positiveandyear") {
      tempResult = await FeedbackDBService.readFeedbackByTwoParam(
          "positive", "year", param, date);
    } else if (filterType == "negativeandmonth") {
      tempResult = await FeedbackDBService.readFeedbackByTwoParam(
          "negative", "month", param, date);
    } else if (filterType == "negativeandyear") {
      tempResult = await FeedbackDBService.readFeedbackByTwoParam(
          "negative", "year", param, date);
    }

    setState(() {
      searchResult = tempResult;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Align(
                  child: Text(
                    "Manage User FeedBack",
                    style: TextStyle(
                      fontSize: screenWidth / 25,
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
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                    child: Text(
                      "Filter By : ",
                      style: TextStyle(
                        fontSize: screenWidth / 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        /////////first Row //////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "name";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "email";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "trainer";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Trainer",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        /////////second Row //////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "month";
                                    paramTextBoxController.text = "";
                                    date = "month";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Month",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "year";
                                    paramTextBoxController.text = "";
                                    date = "year";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Year",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "fullDate";
                                    paramTextBoxController.text = "";
                                    date = "fullDate";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Full Date",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        /////////third Row //////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "rating";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Rating",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "positive";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Positive",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "negative";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Negative",
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        /////////fourth Row //////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "membership";
                                    paramTextBoxController.text = "";
                                    date = "";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Member ship",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "ratingandmonth";
                                    paramTextBoxController.text = "";
                                    date = "month";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Rating & Month",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "ratingandyear";
                                    paramTextBoxController.text = "";
                                    date = "year";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Rating & Year",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        /////////Last Row fifth Row //////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "positiveandmonth";
                                    paramTextBoxController.text = "";
                                    date = "month";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Positive & Month",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "positiveandyear";
                                    paramTextBoxController.text = "";
                                    date = "year";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Positive & Year",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "negativeandmonth";
                                    paramTextBoxController.text = "";
                                    date = "month";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Negative & Month",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4.5,
                              height: screenHeight / 16,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    filterType = "negativeandyear";
                                    paramTextBoxController.text = "";
                                    date = "year";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade400),
                                ),
                                child: Text(
                                  "Negative & Year",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  if (filterType == "name" ||
                      filterType == "email" ||
                      filterType == "trainer" ||
                      filterType == "rating" ||
                      filterType == "positive" ||
                      filterType == "negative" ||
                      filterType == "membership")
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BoxContainerUtil(
                        child: Column(
                          children: [
                            Text("Search By '$filterType' Contains Or Equals"),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: paramTextBoxController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: filterType,
                                hintText: filterType,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (paramTextBoxController.text.isNotEmpty) {
                                  doSearchAndInitFeedBack(
                                      paramTextBoxController.text.trim());
                                } else {
                                  scaffoldUtil(context,
                                      "Search Data Must not be empty", 1);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (filterType == "month" ||
                      filterType == "year" ||
                      filterType == "fullDate")
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BoxContainerUtil(
                        child: Column(
                          children: [
                            Text("Search By '$filterType'"),
                            const SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(3000),
                                  builder: (context, child) {
                                    return Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: SizedBox(
                                              height: 500,
                                              width: 900,
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      if (filterType == "month") {
                                        date = DateFormat('MMMM').format(value);
                                      }
                                      if (filterType == "year") {
                                        date = DateFormat('yyyy').format(value);
                                      }
                                      if (filterType == "fullDate") {
                                        date = DateFormat('dd MMMM yyyy')
                                            .format(value);
                                      }
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height: kToolbarHeight,
                                width: screenWidth * 2,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.only(left: 11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(137, 39, 37, 37),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    date,
                                    style: const TextStyle(
                                      color: Color.fromARGB(77, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (date != "month" &&
                                    date != "year" &&
                                    date != "fullDate" &&
                                    date != "") {
                                  doSearchAndInitFeedBack(
                                      paramTextBoxController.text.trim());
                                } else {
                                  scaffoldUtil(context,
                                      "Search Data Must not be empty", 1);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (filterType == "ratingandmonth" ||
                      filterType == "ratingandyear" ||
                      filterType == "positiveandmonth" ||
                      filterType == "positiveandyear" ||
                      filterType == "negativeandmonth" ||
                      filterType == "negativeandyear")
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BoxContainerUtil(
                        child: Column(
                          children: [
                            Text("Search By '$filterType'"),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: paramTextBoxController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: filterType,
                                hintText: filterType,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showMonthYearPicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(3000),
                                  builder: (context, child) {
                                    return Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: SizedBox(
                                              height: 500,
                                              width: 900,
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      if (filterType == "ratingandmonth" ||
                                          filterType == "positiveandmonth" ||
                                          filterType == "negativeandmonth") {
                                        date = DateFormat('MMMM').format(value);
                                      }
                                      if (filterType == "ratingandyear" ||
                                          filterType == "positiveandyear" ||
                                          filterType == "negativeandyear") {
                                        date = DateFormat('yyyy').format(value);
                                      }
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height: kToolbarHeight,
                                width: screenWidth * 2,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.only(left: 11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(137, 39, 37, 37),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    date,
                                    style: const TextStyle(
                                      color: Color.fromARGB(77, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (date != "month" &&
                                    date != "year" &&
                                    date != "fullDate" &&
                                    date != "" &&
                                    paramTextBoxController.text.isNotEmpty) {
                                  doSearchAndInitFeedBack(
                                      paramTextBoxController.text.trim());
                                } else {
                                  scaffoldUtil(context,
                                      "Search Data Must not be empty", 1);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Text('"Choose a Filter Type First"'),
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(8.0),
                          child: searchResult.isNotEmpty
                              ? const Text("Search Result")
                              : const Text("No Search Data Found!"),
                        ),
                        const Divider(),
                        searchResult.isNotEmpty
                            ? ListView.builder(
                                itemCount: searchResult.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onLongPress: () {},
                                    child: ListTile(
                                      leading: FittedBox(
                                        child: Column(
                                          children: [
                                            Text(
                                              searchResult[index]
                                                  .fullName
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            Text(
                                              searchResult[index]
                                                  .email
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            Text(
                                              searchResult[index]
                                                  .fullDate
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                          ],
                                        ),
                                      ),
                                      title: searchResult[index]
                                                  .positive
                                                  .toString() ==
                                              "true"
                                          ? Column(
                                              children: [
                                                Text(
                                                  "Rating",
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 30,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                                Text(
                                                  searchResult[index]
                                                      .rating
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 35,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Service - ${searchResult[index].service.toString()}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 30,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                                Text(
                                                  "Trainer - ${searchResult[index].trainer.toString()}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 30,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                                Text(
                                                  "Others - ${searchResult[index].other.toString()}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 30,
                                                  ),
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                              ],
                                            ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
