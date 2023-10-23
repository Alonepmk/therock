import 'package:flutter/material.dart';
import 'package:therock/extensions.dart';
import 'package:therock/models/activities.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CuViewActivity extends StatefulWidget {
  final Activity activity;
  const CuViewActivity({Key? key, required this.activity}) : super(key: key);

  @override
  State<CuViewActivity> createState() => _CuViewActivityState();
}

class _CuViewActivityState extends State<CuViewActivity> {
  double screenWidth = 0;
  double screenHeight = 0;

  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    initYoutubePlayer();
  }

  void initYoutubePlayer() async {
    final videoID =
        YoutubePlayer.convertUrlToId(widget.activity.videoLink.toString());
    //print(widget.activity.videoLink.toString());
    if (videoID != null) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoID,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    } else {
      final fixVideoID = YoutubePlayer.convertUrlToId(
          "https://youtube.com/shorts/1H6ybczMrZk?feature=share");
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: fixVideoID!,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    //CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubePlayerController,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: '#141414'.toColor(),
            appBar: AppBar(
              backgroundColor: Colors.grey.shade800.withOpacity(0.5),
              elevation: 20,
              title: Row(
                children: [
                  Align(
                    child: Text(
                      "Activity",
                      style: TextStyle(
                        fontSize: screenWidth / 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 6, 2, 0),
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight / 1.15,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(screenWidth / 45, 6, 0, 0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.activity.activityName}",
                            style: TextStyle(
                              fontSize: screenWidth / 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                          child: Divider(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth,
                          height: screenHeight / 3,
                          child: Text(
                            '          ${widget.activity.activityDescription}',
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 8,
                            style: TextStyle(
                              fontSize: screenWidth / 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 30.0),
                          child: Divider(
                            color: Colors.white24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          width: screenWidth / 2.3,
                          height: screenHeight / 2,
                          child: player,
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
}
