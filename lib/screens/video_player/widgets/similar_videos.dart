import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/provider/api_content.dart';
import 'package:yt_downloader/utils/time_ago.dart';

import '../video_player.dart';

class SimilarVideos extends StatefulWidget {
  const SimilarVideos({Key? key}) : super(key: key);

  @override
  _SimilarVideosState createState() => _SimilarVideosState();
}

class _SimilarVideosState extends State<SimilarVideos> {
  TimeAgo timeAgo = TimeAgo();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Video>>(
        stream: Provider.of<APIContent>(context).similarVideos.stream,
        builder: (context, AsyncSnapshot<List<Video>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.active) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: ListView(
                children: snapshot.data!.map<Widget>(listItem).toList(),
              ),
            );
          } else {
            return const Text("Error");
          }
        });
  }

  Widget listItem(Video video) {
    return InkWell(
      onTap: () {
        Provider.of<APIContent>(context,listen: false).clearSimilarSearch();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return VideoPlayer(video: video);
          }),
        );
      },
      child: Card(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 7.0),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Stack(
                  children: [
                    Image.network(
                      video.thumbnails.highResUrl,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    video.duration == null
                        ? Container()
                        : Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 5.0, right: 5.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 5.0),
                            color: Colors.black,
                            child: Text(
                              timeAgo.formatDuration(video.duration!),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    contentText(
                      video.title
                          .replaceAll('&quot;', "'")
                          .replaceAll('&#39;', "'")
                          .replaceAll('&amp;', '&'),
                      2,
                      15,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                      text: TextSpan(
                        text: numeral(video.engagement.viewCount,
                            fractionDigits: 0),
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black87),
                        children: <TextSpan>[
                          const TextSpan(
                              text: " · ",
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          video.uploadDate == null
                              ? const TextSpan(text: 'No Data')
                              : TextSpan(
                              text:
                              timeAgo.uploadTimeAgo(video.uploadDate!)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    contentText(
                      video.author,
                      1,
                      12,
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    contentText(
                      video.description,
                      2,
                      12,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                  icon: const Icon(
                    EvaIcons.moreVertical,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Share"),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("Add to Favourites"),
                      value: 2,
                    ),
                    const PopupMenuItem(
                      child: Text("Download"),
                      value: 2,
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Widget contentText(String text, int maxLines, double fontSize) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      softWrap: true,
      style: TextStyle(fontSize: fontSize, color: Colors.grey),
    );
  }
}
