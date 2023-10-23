import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/program.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_program/create_new_program.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_program/ud_program.dart';
import 'package:therock/services/program_db_services.dart';
import 'package:intl/intl.dart';

class ManageProgram extends StatefulWidget {
  const ManageProgram({super.key});

  @override
  State<ManageProgram> createState() => _ManageProgramState();
}

class _ManageProgramState extends State<ManageProgram> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Align(
              child: Text(
                "Manage Program",
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
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: StreamBuilder<List<Program>>(
              stream: ProgramDBService.read(),
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
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: Card(
                              // clipBehavior is necessary because, without it, the InkWell's animation
                              // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                              // This comes with a small performance cost, and you should not set [clipBehavior]
                              // unless you need it.
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onLongPress: () {
                                  debugPrint('Card tapped. $snapshot');
                                  Get.to(
                                    () => UdProgram(
                                      program: Program(
                                        pid: snapshot.data?[index].pid,
                                        programName:
                                            snapshot.data?[index].programName,
                                        programDescription: snapshot
                                            .data?[index].programDescription,
                                        programCreatedDate: snapshot
                                            .data?[index].programCreatedDate,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: screenWidth / 1.1,
                                  height: screenHeight / 5.5,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth / 3.2,
                                        height: screenHeight / 5.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            color: Colors.lightBlueAccent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                              )
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Program : \n ${snapshot.data?[index].programName}',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              'Description : ${snapshot.data?[index].programDescription}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 25,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              "Date: ${DateFormat('dd/mm/yy').format(snapshot.data![index].programCreatedDate!.toDate())}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 25,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Create a Program",
        elevation: 3,
        backgroundColor: Colors.pink.withOpacity(0.4),
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          Get.to(
            () => const CreateAnewProgram(),
          );
        },
      ),
    );
  }
}
