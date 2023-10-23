import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/cms.dart';

class CmsInfo extends StatefulWidget {
  final Cms cms;
  const CmsInfo({Key? key, required this.cms}) : super(key: key);
  @override
  State<CmsInfo> createState() => _CmsInfoState();
}

class _CmsInfoState extends State<CmsInfo> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    // CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: '#141414'.toColor(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          focusColor: Colors.white54,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
              shadows: [
                const Shadow(
                    offset: Offset(-1, -1),
                    color: Color.fromARGB(95, 255, 255, 255),
                    blurRadius: 3),
                Shadow(
                    offset: const Offset(1, 1),
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.85),
                    blurRadius: 3)
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight / 2,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(150.0),
                    // bottomLeft: Radius.circular(80.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 4,
                        blurRadius: 10.0,
                        offset: Offset(2.0, 2.0))
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(150.0),
                    // bottomLeft: Radius.circular(80.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.cms.cmsPicLink.toString(),
                    imageBuilder: (context, imageProvider) => Container(
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
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.only(right: 20),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(100.0),
                    // bottomLeft: Radius.circular(80.0),
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 4,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 4, 8),
                      child: Text(
                        "${widget.cms.cmsTitle}",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: screenWidth / 26,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 4, 8),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '     ${widget.cms.description}',
                              style: TextStyle(
                                fontSize: screenWidth / 38,
                                color: Colors.white30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
