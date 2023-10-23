import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therock/models/cms.dart';
import 'package:therock/screens/user_screens/users_shared_screens/cms_info.dart';
import 'package:therock/utils/text_theme.dart';

class CmsContainer extends StatefulWidget {
  const CmsContainer({super.key});

  @override
  State<CmsContainer> createState() => _CmsContainerState();
}

class _CmsContainerState extends State<CmsContainer> {
  List<Cms> cmsList = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    await FirebaseFirestore.instance.collection("cms").get().then(
      (querySnapshot) {
        debugPrint("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          var snapshot = docSnapshot.data();
          Cms cms = Cms(
              cid: docSnapshot.id,
              cmsName: snapshot['cmsName'],
              cmsTitle: snapshot['cmsTitle'],
              description: snapshot['description'],
              cmsPicLink: snapshot['cmsPicLink']);
          setState(() {
            cmsList.add(cms);
          });
          //print('${docSnapshot.id} => ${snapshot["role"]}');
          //print(trainerList[0].email);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    //CarouselController controller = CarouselController();
    return Container(
      height: 210,
      margin: const EdgeInsets.only(top: 8),
      width: double.maxFinite,
      child: Column(
        children: [
          CarouselSlider(
            //carouselController: controller,
            items: cmsList
                .map((item) => Center(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: item.cmsPicLink.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 10,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    () => CmsInfo(
                                      cms: Cms(
                                        cid: item.cid,
                                        cmsName: item.cmsName,
                                        cmsTitle: item.cmsTitle,
                                        description: item.description,
                                        cmsPicLink: item.cmsPicLink,
                                      ),
                                    ),
                                  );
                                },
                                child: item.description != null
                                    ? Row(
                                        children: [
                                          Text(
                                            "see more...",
                                            style: ThemeTextGym
                                                .textShadowInHomePageCMS,
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            left: 0.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 10,
                              ),
                              child: item.cmsTitle != null
                                  ? Row(
                                      children: [
                                        Text(
                                          item.cmsTitle.toString(),
                                          style: ThemeTextGym
                                              .textShadowInHomePageCMS,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                autoPlayInterval: const Duration(seconds: 8),
                autoPlayAnimationDuration: const Duration(seconds: 2),
                onPageChanged: (index, reason) {
                  setState(
                    () {
                      currentIndex = index;
                    },
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cmsList.map((urlOfItem) {
              int index = cmsList.indexOf(urlOfItem);
              return Container(
                width: 10.0,
                height: 10.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? Colors.white
                      : const Color.fromRGBO(207, 45, 45, 0.298),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
    // return Container(
    //   //set up the CMS images
    //   height: 250,
    //   width: double
    //       .infinity, //so the width of parent maintain when the children widgets come
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //     image: const DecorationImage(
    //       image: AssetImage('assets/gym-cms-1.png'),
    //       fit: BoxFit.cover,
    //     ),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.green.withOpacity(0.2),
    //         spreadRadius: 2,
    //         blurRadius: 6,
    //         offset: Offset(0, 3), // changes position of shadow
    //       ),
    //     ],
    //   ),
    //   child: Container(
    //     decoration: BoxDecoration(
    //       //For settting up the image gradient
    //       borderRadius: BorderRadius.circular(20),
    //       gradient: LinearGradient(
    //         begin: Alignment.bottomRight,
    //         colors: [
    //           Colors.black.withOpacity(.7),
    //           Colors.black.withOpacity(.3),
    //         ],
    //       ),
    //     ),
    //     child: Column(
    //       // mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: <Widget>[
    //         const Text(
    //           "Gym Running Activities",
    //           maxLines: 1,
    //           overflow: TextOverflow.ellipsis,
    //           softWrap: true,
    //           style: TextStyle(
    //             color: Color.fromARGB(255, 63, 62, 62),
    //             fontSize: 30,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         const SizedBox(height: 30),
    //         Container(
    //           child: TextButton(
    //               onPressed: () {}, child: Text("Click here to see more")),
    //         ),
    //         SizedBox(height: 30),
    //       ],
    //     ),
    //   ),
    // );
  }
}
