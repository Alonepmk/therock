import 'package:flutter/material.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util_cu.dart';
import 'package:provider/provider.dart';

class CuFeedback extends StatefulWidget {
  const CuFeedback({super.key});

  @override
  State<CuFeedback> createState() => _CuFeedbackState();
}

class _CuFeedbackState extends State<CuFeedback> {
  double screenWidth = 0;
  double screenHeight = 0;

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    //GymUser user = currentUser.getCurrentUser;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 28, 28, 21),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome ${currentUser.getCurrentUser.fullName}",
                    style: TextStyle(
                      fontSize: screenWidth / 20,
                      color: Colors.white60,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Feedback is Imprtant for us",
                    style: TextStyle(
                      fontSize: screenWidth / 32,
                      color: Colors.white60,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white30,
                  ),
                ),
                SizedBox(
                  width: screenWidth,
                  height: screenWidth / 1.33,
                  child: BoxContainerUtilCu(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Feed Back",
                              style: TextStyle(
                                fontSize: screenWidth / 20,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              controller: subjectController,
                              style: const TextStyle(color: Colors.white70),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                labelText: "Subject",
                                hintText: "Subject",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.justify,
                              minLines: 10,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                labelText: "Message",
                                hintText: "Message",
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showLoadingDialogUtil(context);
                              // Feedback fb = Feedback();
                              scaffoldUtil(
                                  context, "Thanks For Your Feedback", 1);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: kToolbarHeight,
                              width: screenWidth,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.red,
                              ),
                              child: const Center(
                                child: Text(
                                  "Send Feedback",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
