// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/program.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_program/manage_activities/manage_activities.dart';
import 'package:therock/services/program_db_services.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class UdProgram extends StatefulWidget {
  final Program program;
  const UdProgram({Key? key, required this.program}) : super(key: key);
  @override
  State<UdProgram> createState() => _UdProgramState();
}

class _UdProgramState extends State<UdProgram> {
  double screenWidth = 0;
  double screenHeight = 0;
  TextEditingController _programNameController = TextEditingController();
  TextEditingController _programDescriptionController = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    super.initState();
    debugPrint("the pid is ${widget.program.pid}");
    _programNameController =
        TextEditingController(text: widget.program.programName);
    _programDescriptionController =
        TextEditingController(text: widget.program.programDescription);
  }

  void _updateProgram(String programName, String programDescription,
      BuildContext context) async {
    showLoadingDialogUtil(context);
    Program program = Program(
        pid: widget.program.pid,
        programName: programName,
        programDescription: programDescription);
    rds.status = await ProgramDBService.updateProgram(program);
    if (rds.status == "success") {
      scaffoldUtil(context, "Successfully updated the data", 1);
      Navigator.pop(context);
    } else {
      scaffoldUtil(context, "Something went wrong", 1);
      Navigator.pop(context);
    }
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
            title: const Text("Update Program"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BoxContainerUtil(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _programNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Program Name",
                            hintText: "Program Name",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _programDescriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Program Description",
                            hintText: "Program Description",
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            updateProgramConfirmDialog(context);
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
                                  Icons.update_sharp,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Update",
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BoxContainerUtil(
                      child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        const Text("Manage Activities in this Program"),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.to(
                              () => ManageActivities(pid: widget.program.pid),
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.manage_search,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Manage Activities",
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
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProgramConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(child: Text("!You sure want to Update this Program?")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                showLoadingDialogUtil(context);
                await Future.delayed(const Duration(seconds: 2));

                if (_programNameController.text == "") {
                  scaffoldUtil(context, "Please fill the program name", 1);
                } else if (_programDescriptionController.text == "") {
                  scaffoldUtil(
                      context, "Please fill the program description", 1);
                } else {
                  _updateProgram(_programNameController.text,
                      _programDescriptionController.text, context);
                }

                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
