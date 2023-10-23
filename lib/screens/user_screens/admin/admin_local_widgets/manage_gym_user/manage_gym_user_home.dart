// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/gym_user.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_gym_user/create_new_gym_user.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_gym_user/ud_gym_user.dart';
import 'package:therock/services/gym_user_db_service.dart';

class ManageGymUser extends StatefulWidget {
  const ManageGymUser({super.key});

  @override
  State<ManageGymUser> createState() => _ManageGymUserState();
}

class _ManageGymUserState extends State<ManageGymUser> {
  double screenWidth = 0;
  double screenHeight = 0;

  bool sort = true;
  List<GymUser>? filterData;

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.fullName!.compareTo(b.fullName!));
      } else {
        filterData!.sort((a, b) => b.fullName!.compareTo(a.fullName!));
      }
    }
  }

  @override
  void initState() {
    //filterData = myData;
    //print(myData.toList());
    super.initState();
  }

  TextEditingController controller = TextEditingController();

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
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: StreamBuilder<List<GymUser>>(
                      stream: GymUserDBService.read(),
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
                          // print(snapshot.data![1].fullName);
                          return PaginatedDataTable(
                            columnSpacing: 10,
                            source: RowSource(
                                myData: snapshot.data,
                                count: snapshot.data!.length),
                            columns: [
                              DataColumn(
                                  label: const Text(
                                    "Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      sort = !sort;
                                    });

                                    onsortColum(columnIndex, ascending);
                                  }),
                              const DataColumn(
                                label: Text(
                                  "Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  "Role",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          );
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
    );
  }
}

class RowSource extends DataTableSource {
  var myData;
  final count;
  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(
      cells: [
        DataCell(Text(data.fullName ?? "Name")),
        DataCell(Text(data.email.toString())),
        DataCell(Text(data.role.toString())),
      ],
      onLongPress: () {
        //print(data.uid);

        Get.to(
          () => AdminCrudGymUser(
            gymUser: GymUser(
              uid: data.uid,
              email: data.email,
              fullName: data.fullName,
              address: data.address,
              phoneNumber: data.phoneNumber,
              profilePicLink: data.profilePicLink,
              dob: data.dob,
              role: data.role,
              trainnerUid: data.trainnerUid,
              trainnerName: data.trainnerName,
              pid: data.pid,
              programName: data.programName,
              currentMembershipId: data.currentMembershipId,
              currentMembershipName: data.currentMembershipName,
              hasCurrentMembership: data.hasCurrentMembership,
              membershipStartDate: data.membershipStartDate,
              membershipEndDate: data.membershipEndDate,
              isLogin: data.isLogin,
              accountCreated: data.accountCreated,
            ),
          ),
        );
      });
}
