// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/models/program.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/services/program_db_services.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class CreateAnewProgram extends StatefulWidget {
  const CreateAnewProgram({super.key});

  @override
  State<CreateAnewProgram> createState() => _CreateAnewProgramState();
}

class _CreateAnewProgramState extends State<CreateAnewProgram> {
  TextEditingController programNameController = TextEditingController();
  TextEditingController programDescriptionController = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    super.initState();
  }

  void _createAnewProgram(String programName, String programDescription,
      BuildContext context) async {
    showLoadingDialogUtil(context);
    Program program = Program(
        programName: programName, programDescription: programDescription);
    rds.status = await ProgramDBService.createProgram(program);
    if (rds.status == "success") {
      scaffoldUtil(context, "Successfully added the data", 1);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      scaffoldUtil(context, "Something went wrong", 1);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create a new Program"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BoxContainerUtil(
                child: Column(
                  children: [
                    TextFormField(
                      controller: programNameController,
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
                      controller: programDescriptionController,
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

                        if (programNameController.text == "") {
                          scaffoldUtil(
                              context, "Please fill the program name", 1);
                        } else if (programDescriptionController.text == "") {
                          scaffoldUtil(context,
                              "Please fill the program description", 1);
                        } else {
                          _createAnewProgram(programNameController.text,
                              programDescriptionController.text, context);
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
