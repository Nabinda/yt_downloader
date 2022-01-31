import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yt_downloader/provider/api_content.dart';
import 'package:yt_downloader/screens/video_player/widgets/similar_videos.dart';
import 'package:yt_downloader/screens/video_player/widgets/video_details.dart';

class VideoPlayer extends StatefulWidget {
  static const routeName = '/video_player';
  final Video video;
  const VideoPlayer({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  late String id;
  @override
  void initState() {
    id = widget.video.id.value.toString();
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        hideControls: false,
        controlsVisibleAtStart: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<APIContent>(context,listen: false).retriveSimilarVideos(widget.video.id.toString());
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
          aspectRatio: 16 / 9,
          liveUIColor: Colors.red,
          progressColors: const ProgressBarColors(
              backgroundColor: Colors.white,
              bufferedColor: Colors.redAccent,
              handleColor: Colors.red,
              playedColor: Colors.red),
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.redAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                widget.video.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
                onPressed: () {
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ))
          ]),
      builder: (context, player) => Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy > 800) {
                    Navigator.of(context).pop();
                  }
                },
                child: player),
            const SizedBox(height: 10,),
            VideoDetails(video: widget.video),
            const SimilarVideos()
          ],
        ),
      ),
    );
  }
}
