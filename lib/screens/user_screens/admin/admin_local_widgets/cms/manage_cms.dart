import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/cms.dart';
import 'package:therock/screens/user_screens/admin/admin_local_widgets/cms/ud_cms.dart';
import 'package:therock/services/cms_db_service.dart';

class ManageCms extends StatefulWidget {
  const ManageCms({super.key});

  @override
  State<ManageCms> createState() => _ManageCmsState();
}

class _ManageCmsState extends State<ManageCms> {
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
                "Manage Gym CMS",
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
          child: StreamBuilder<List<Cms>>(
              stream: CmsDBService.readCmsList(),
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
                                  () => UdCms(
                                    cms: Cms(
                                      cid: snapshot.data?[index].cid,
                                      cmsName: snapshot.data?[index].cmsName,
                                      cmsTitle: snapshot.data?[index].cmsTitle,
                                      description:
                                          snapshot.data?[index].description,
                                      cmsPicLink:
                                          snapshot.data?[index].cmsPicLink,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                "${snapshot.data![index].cmsName}",
                                style: TextStyle(
                                  fontSize: screenWidth / 25,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Title : ${snapshot.data![index].cmsTitle}",
                                  style: TextStyle(
                                    fontSize: screenWidth / 30,
                                    overflow: TextOverflow.ellipsis,
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
    );
  }
}
