// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/models/membership.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/services/membership_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class UdMembership extends StatefulWidget {
  final Membership membership;
  const UdMembership({Key? key, required this.membership}) : super(key: key);
  @override
  State<UdMembership> createState() => _UdMembershipState();
}

class _UdMembershipState extends State<UdMembership> {
  TextEditingController _membershipTypeController = TextEditingController();
  TextEditingController _membershipDescriptionController =
      TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    super.initState();
    _membershipTypeController =
        TextEditingController(text: widget.membership.membershipType);
    _membershipDescriptionController =
        TextEditingController(text: widget.membership.membershipDescription);
  }

  void _updateMembership(String membershipType, String membershipDescription,
      BuildContext context) async {
    showLoadingDialogUtil(context);
    Membership membership = Membership(
        mid: widget.membership.mid,
        membershipType: membershipType,
        membershipDescription: membershipDescription);
    rds.status = await MembershipDBService.updateMembership(membership);
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
            title: const Text("Create a new Membership"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BoxContainerUtil(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _membershipTypeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Membership Type",
                        hintText: "Membership Type",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _membershipDescriptionController,
                      textAlign: TextAlign.justify,
                      minLines: 15,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Membership Description",
                        hintText: "Membership Description",
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (_membershipTypeController.text == "") {
                          scaffoldUtil(
                              context, "Please fill the membership type", 1);
                        } else if (_membershipDescriptionController.text ==
                            "") {
                          scaffoldUtil(context,
                              "Please fill the membership description", 1);
                        } else {
                          _updateMembership(_membershipTypeController.text,
                              _membershipDescriptionController.text, context);
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
          ),
        ),
      ),
    );
  }
}
