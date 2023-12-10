// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_gym_user/create_new_gym_user.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_gym_user/ud_gym_user.dart';
import 'package:therock/services/gym_user_db_service.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class ManageGymUser extends StatefulWidget {
  const ManageGymUser({super.key});

  @override
  State<ManageGymUser> createState() => _ManageGymUserState();
}

class _ManageGymUserState extends State<ManageGymUser> {
  double screenWidth = 0;
  double screenHeight = 0;
  String filterName = "";
  String filterEmail = "";
  String filterType = "";
  List<GymUser> searchResult = [];
  TextEditingController paramTextBoxController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    //filterData = myData;
    //print(myData.toList());
    super.initState();
  }

  void doSearchAndInitUser(String param) async {
    List<GymUser> tempResult = [];
    if (filterType == "name") {
      tempResult = await GymUserDBService.readUserByName(param);
    } else if (filterType == "email") {
      tempResult = await GymUserDBService.readUserByEmail(param);
    } else {
      tempResult = await GymUserDBService.readUserByPhone(param);
    }

    setState(() {
      searchResult = tempResult;
    });
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
                    "Manage Gym User",
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
                    child: Row(
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
                                filterType = "phone";
                                paramTextBoxController.text = "";
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blue.shade400),
                            ),
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                fontSize: screenWidth / 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  filterType != ""
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BoxContainerUtil(
                            child: Column(
                              children: [
                                Text(
                                    "Search By '$filterType' Contains Or Equals"),
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (paramTextBoxController
                                        .text.isNotEmpty) {
                                      if (filterType == "phone") {
                                        if (paramTextBoxController
                                                .text.length >=
                                            4) {
                                          doSearchAndInitUser(
                                              paramTextBoxController.text
                                                  .trim());
                                        } else {
                                          scaffoldUtil(
                                              context,
                                              "Phone Number Length must be at least 4 digit",
                                              1);
                                        }
                                      } else {
                                        doSearchAndInitUser(
                                            paramTextBoxController.text.trim());
                                      }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      : const Text('"Choose a Filter Type First"'),
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
                                    onLongPress: () {
                                      Get.to(
                                        () => AdminCrudGymUser(
                                          gymUser: GymUser(
                                            uid: searchResult[index].uid,
                                            email: searchResult[index].email,
                                            fullName:
                                                searchResult[index].fullName,
                                            address:
                                                searchResult[index].address,
                                            phoneNumber:
                                                searchResult[index].phoneNumber,
                                            profilePicLink: searchResult[index]
                                                .profilePicLink,
                                            dob: searchResult[index].dob,
                                            role: searchResult[index].role,
                                            trainnerUid:
                                                searchResult[index].trainnerUid,
                                            trainnerName: searchResult[index]
                                                .trainnerName,
                                            pid: searchResult[index].pid,
                                            programName:
                                                searchResult[index].programName,
                                            currentMembershipId:
                                                searchResult[index]
                                                    .currentMembershipId,
                                            currentMembershipName:
                                                searchResult[index]
                                                    .currentMembershipName,
                                            hasCurrentMembership:
                                                searchResult[index]
                                                    .hasCurrentMembership,
                                            membershipStartDate:
                                                searchResult[index]
                                                    .membershipStartDate,
                                            membershipEndDate:
                                                searchResult[index]
                                                    .membershipEndDate,
                                            isLogin:
                                                searchResult[index].isLogin,
                                            accountCreated: searchResult[index]
                                                .accountCreated,
                                          ),
                                        ),
                                      );
                                    },
                                    child: searchResult[index]
                                                .role
                                                .toString() !=
                                            "admin"
                                        ? ListTile(
                                            leading: Text(
                                              searchResult[index]
                                                  .fullName
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 30,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            title: Text(
                                              searchResult[index]
                                                  .email
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            subtitle: Text(
                                              searchResult[index]
                                                  .phoneNumber
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 35,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                            trailing: Text(
                                              searchResult[index]
                                                  .role
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: screenWidth / 30,
                                              ),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                          )
                                        : Container(),
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
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            tooltip: "Create a User",
            elevation: 3,
            backgroundColor: Colors.pink.withOpacity(0.4),
            child: const Icon(Icons.add_outlined),
            onPressed: () {
              Get.to(
                () => const CreateAnewGymUser(),
              );
            },
          ),
        ),
      ),
    );
  }
}



// DataRow recentFileDataRow(var data) {
//   return DataRow(
//       cells: [
//         DataCell(Text(data.fullName ?? "Name")),
//         DataCell(Text(data.email.toString())),
//         DataCell(Text(data.role.toString())),
//       ],
//       onLongPress: () {
//         //print(data.uid);

//         Get.to(
//           () => AdminCrudGymUser(
//             gymUser: GymUser(
//               uid: data.uid,
//               email: data.email,
//               fullName: data.fullName,
//               address: data.address,
//               phoneNumber: data.phoneNumber,
//               profilePicLink: data.profilePicLink,
//               dob: data.dob,
//               role: data.role,
//               trainnerUid: data.trainnerUid,
//               trainnerName: data.trainnerName,
//               pid: data.pid,
//               programName: data.programName,
//               currentMembershipId: data.currentMembershipId,
//               currentMembershipName: data.currentMembershipName,
//               hasCurrentMembership: data.hasCurrentMembership,
//               membershipStartDate: data.membershipStartDate,
//               membershipEndDate: data.membershipEndDate,
//               isLogin: data.isLogin,
//               accountCreated: data.accountCreated,
//             ),
//           ),
//         );
//       });
// }
