import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/trainer_show_profile.dart';

class ViewTrainerDetail extends StatefulWidget {
  final TrainerShowProfile tsp;
  const ViewTrainerDetail({Key? key, required this.tsp}) : super(key: key);

  @override
  State<ViewTrainerDetail> createState() => _ViewTrainerDetailState();
}

class _ViewTrainerDetailState extends State<ViewTrainerDetail> {
  double screenWidth = 0;
  double screenHeight = 0;

  List<String> showPicList = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    setState(() {
      showPicList.add(widget.tsp.showPicOne!);
      showPicList.add(widget.tsp.showPicTwo!);
      showPicList.add(widget.tsp.showPicThree!);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      backgroundColor: '#141414'.toColor(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        elevation: 20,
        title: Row(
          children: [
            Align(
              child: Text(
                "Trainer Detail",
                style: TextStyle(
                  fontSize: screenWidth / 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 12),
          child: Column(
            children: [
              Container(
                height: screenHeight / 3.5,
                margin: const EdgeInsets.only(top: 8),
                width: double.maxFinite,
                child: Column(
                  children: [
                    CarouselSlider(
                      //carouselController: controller,
                      items: showPicList
                          .map((item) => Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: item.toString(),
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
                              //currentIndex = index;
                            },
                          );
                        },
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: cmsList.map((urlOfItem) {
                    //     int index = cmsList.indexOf(urlOfItem);
                    //     return Container(
                    //       width: 10.0,
                    //       height: 10.0,
                    //       margin: const EdgeInsets.symmetric(
                    //           vertical: 10.0, horizontal: 2.0),
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: currentIndex == index
                    //             ? Colors.white
                    //             : const Color.fromRGBO(207, 45, 45, 0.298),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                  ],
                ),
              ),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 1.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.tsp.profileLink!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: screenWidth / 4,
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.brown,
                              blurRadius: 5.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: Colors.tealAccent,
                      ),
                      child: CircleAvatar(
                        radius: screenWidth / 12,
                        backgroundImage: imageProvider,
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tsp.nickName.toString(),
                        style: TextStyle(
                          fontSize: screenWidth / 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.tsp.contactEmail.toString(),
                        style: TextStyle(
                          fontSize: screenWidth / 35,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 1.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Container(
                //height: screenWidth / 15,
                padding: EdgeInsets.only(left: screenWidth / 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Bio",
                  style: TextStyle(
                    fontSize: screenWidth / 25,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                //height: screenHeight / 2.5,
                padding: EdgeInsets.only(left: screenWidth / 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.tsp.bio.toString(),
                  style: TextStyle(
                    fontSize: screenWidth / 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
