// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:therock/models/cms.dart';
import 'package:therock/models/return_string_carrier.dart';
import 'package:therock/services/cms_db_service.dart';
import 'package:therock/utils/loading_dialog.dart';
import 'package:therock/utils/one_message_scaffold.dart';
import 'package:therock/widgets/box_container_util.dart';

class UdCms extends StatefulWidget {
  final Cms cms;
  const UdCms({Key? key, required this.cms}) : super(key: key);
  @override
  State<UdCms> createState() => _UdCmsState();
}

class _UdCmsState extends State<UdCms> {
  TextEditingController _cmsName = TextEditingController();
  TextEditingController _cmsTitle = TextEditingController();
  TextEditingController _cmsDescription = TextEditingController();
  TextEditingController _cmsPicLink = TextEditingController();
  ReturnDataString rds = ReturnDataString();

  @override
  void initState() {
    super.initState();
    _cmsName = TextEditingController(text: widget.cms.cmsName);
    _cmsTitle = TextEditingController(text: widget.cms.cmsTitle);
    _cmsDescription = TextEditingController(text: widget.cms.description);
    _cmsPicLink = TextEditingController(text: widget.cms.cmsPicLink);
  }

  void _updateCms(String name, String title, String description, String link) {
    String splitted = "";
    if (link.contains("export")) {
      splitted = link;
    } else {
      List<String> tempStr = link.split('/');
      splitted = "https://drive.google.com/uc?export=view&id=${tempStr[5]}";
    }
    Cms cms = Cms(
        cid: widget.cms.cid,
        cmsName: name,
        cmsTitle: title,
        description: description,
        cmsPicLink: splitted);
    CmsDBService.updateCms(cms);
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
            title: const Text("Update CMS"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BoxContainerUtil(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cmsName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "CMS Name",
                        hintText: "CMS Name",
                        enabled: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _cmsTitle,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "CMS Title",
                        hintText: "CMS Title",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _cmsDescription,
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
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _cmsPicLink,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "CMS Pic Link",
                        hintText: "CMS Pic Link",
                        suffixIcon: IconButton(
                          onPressed: _cmsPicLink.clear,
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        updateMembershipConfirmDialog(context);
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

  void updateMembershipConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: Text("!You sure want to update this Membership?")),
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

                FocusManager.instance.primaryFocus?.unfocus();

                if (_cmsDescription.text == "") {
                  scaffoldUtil(context, "Please fill the cms Description", 1);
                } else if (_cmsPicLink.text == "") {
                  scaffoldUtil(context,
                      "Please fill the CMS Picture Google drive link", 1);
                } else if (_cmsTitle.text == "") {
                  scaffoldUtil(context, "Please fill the CMS Title", 1);
                } else {
                  _updateCms(_cmsName.text, _cmsTitle.text,
                      _cmsDescription.text, _cmsPicLink.text);
                }
                scaffoldUtil(context, "Successfully Updated", 1);
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
