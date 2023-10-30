import 'package:flutter/material.dart';
import 'package:skywatch/clients/video.client.dart';
import 'package:skywatch/global.dart';
import 'package:video_player/video_player.dart';

class WeatherStoryPlayer extends StatefulWidget {
  const WeatherStoryPlayer({
    super.key,
  });

  @override
  State<WeatherStoryPlayer> createState() => _WeatherStoryPlayerState();
}

class _WeatherStoryPlayerState extends State<WeatherStoryPlayer> {
  VideoPlayerController? videoPlayerController;
  late List<String> videoList;
  int videoIndex = 0;

  // final List<String> videoList = [
  //   "https://player.vimeo.com/external/430274399.hd.mp4?s=4891ad209abedb1d19da5efd3ab48317888c9484&profile_id=174&oauth2_token_id=57447761",
  //   "https://player.vimeo.com/external/472162467.sd.mp4?s=3519d8f4529db5b8475be9f37b41f1052f78b05c&profile_id=164&oauth2_token_id=57447761",
  //   "https://player.vimeo.com/external/538575833.sd.mp4?s=a789a6da0dbe1e5353b671887e571502fd567255&profile_id=165&oauth2_token_id=57447761",
  // ];

  @override
  void initState() {
    loadWeatherVideos();
    super.initState();
  }

  loadWeatherVideos() async {
    if (Global.location != null) {
      List<DbVideo>? videos =
          await VideoClient.getVideoListAround(Global.location!);
      if (videos.isNotEmpty == true) {
        videoList = videos.map((video) => video.videoUrl).toList();
        displayVideoBackgound();
      }
    }
  }

  displayVideoBackgound() async {
    videoPlayerController?.removeListener(checkVideoProgress);
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoList[videoIndex]));
    videoPlayerController!.initialize().then((value) {
      if (videoIndex != videoList.length - 1) {
        videoIndex++;
      } else {
        videoIndex = 0;
      }
      // videoPlayerController!.setLooping(true);
      videoPlayerController!.setVolume(0);
      videoPlayerController!.addListener(checkVideoProgress);
      setState(() {});
      Future.microtask(() => videoPlayerController!.play());
    });
  }

  checkVideoProgress() {
    if (videoPlayerController!.value.duration ==
        videoPlayerController!.value.position) {
      displayVideoBackgound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController != null
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                width: videoPlayerController!.value.size.width,
                height: videoPlayerController!.value.size.height,
                child: VideoPlayer(videoPlayerController!)),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(checkVideoProgress);
    super.dispose();
  }
}
