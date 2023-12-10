// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:therock/models/gym_user_roles.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/states/current_user.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';
import 'package:provider/provider.dart';

class CreateAnewGymUser extends StatefulWidget {
  const CreateAnewGymUser({super.key});

  @override
  State<CreateAnewGymUser> createState() => _CreateAnewGymUserState();
}

class _CreateAnewGymUserState extends State<CreateAnewGymUser> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tempPasswordController = TextEditingController();
  TextEditingController _roleController = TextEditingController();

  final List<String> _roleDropDown = [
    describeEnum(GymUserRole.currentUser),
    describeEnum(GymUserRole.pastUser),
    describeEnum(GymUserRole.trainer),
    describeEnum(GymUserRole.guest),
  ];

  @override
  void initState() {
    super.initState();
    _roleController =
        TextEditingController(text: describeEnum(GymUserRole.guest));
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create a new Gym Member"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BoxContainerUtil(
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "User Name",
                        hintText: "User Name",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Temporary Password",
                        hintText: "Temporary Password",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: tempPasswordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirm Temporary Password",
                        hintText: "Confirm Temporary Password",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          //margin: const EdgeInsets.all(15.0),
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButton(
                            dropdownColor: Colors.lightBlue,
                            hint: const Text(
                                'Select Role'), // Not necessary for Option 1
                            value: _roleController.text,
                            onChanged: (newValue) {
                              setState(() {
                                _roleController = TextEditingController(
                                    text: newValue.toString());
                              });
                            },
                            items: _roleDropDown.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(
                                  role,
                                  //style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () async {
                        //GymUser newUser = GymUser();
                        if (fullNameController.text.isEmpty) {
                          scaffoldUtil(context, "Please Fill Full Name", 1);
                        } else if (emailController.text.isEmpty) {
                          scaffoldUtil(context, "Please Fill Email", 1);
                        } else if (passwordController.text !=
                            tempPasswordController.text) {
                          scaffoldUtil(context, "Password Must be Match", 1);
                        } else {
                          showLoadingDialogUtil(context);
                          ReturnDataString rds = ReturnDataString();

                          rds = await currentUser.adminCreateANewUser(
                              emailController.text.toLowerCase().trim(),
                              passwordController.text,
                              fullNameController.text.toLowerCase().trim());

                          try {
                            if (rds.status == "success") {
                              scaffoldUtil(
                                  context, "User Successfully Created", 1);
                              Navigator.pop(context);
                              Navigator.pop(context);

                              //scaffoldUtil(context, rds.message!, 1);
                              // await Future.delayed(Duration(seconds: 2));
                              // Navigator.pop(context);
                            } else {
                              //scaffoldUtil(context, rds.message!, 1);
                              // await Future.delayed(Duration(seconds: 2));
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            debugPrint(e.toString());
                          }
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
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Create",
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
            ),
          ),
        ),
      ),
    );
  }
}
