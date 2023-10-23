import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/membership.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_membership/create_membership.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/manage_membership/ud_membership.dart';
import 'package:therock/services/membership_db_service.dart';
import 'package:intl/intl.dart';

class ManageMembership extends StatefulWidget {
  const ManageMembership({super.key});

  @override
  State<ManageMembership> createState() => _ManageMembershipState();
}

class _ManageMembershipState extends State<ManageMembership> {
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
                "Manage Membership",
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
          padding: const EdgeInsets.only(top: 15, bottom: 30),
          child: StreamBuilder<List<Membership>>(
              stream: MembershipDBService.readMembership(),
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(Icons.list),
                              onTap: () {
                                Get.to(
                                  () => UdMembership(
                                    membership: Membership(
                                      mid: snapshot.data?[index].mid,
                                      membershipType:
                                          snapshot.data?[index].membershipType,
                                      membershipDescription: snapshot
                                          .data?[index].membershipDescription,
                                      membershipCreatedDate: snapshot
                                          .data?[index].membershipCreatedDate,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                "${snapshot.data![index].membershipType}",
                                style: TextStyle(
                                  fontSize: screenWidth / 25,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Date: ${DateFormat('dd/mm/yy').format(snapshot.data![index].membershipCreatedDate!.toDate())}",
                                  style: TextStyle(
                                    fontSize: screenWidth / 30,
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
        tooltip: "Create a Membership",
        elevation: 3,
        backgroundColor: Colors.pink.withOpacity(0.4),
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          Get.to(
            () => const CreateMembership(),
          );
        },
      ),
    );
  }
}
