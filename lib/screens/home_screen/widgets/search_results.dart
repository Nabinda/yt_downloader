import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:numeral/fun.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/screens/video_player/video_player.dart';
import '/provider/api_content.dart';
import 'package:yt_downloader/utils/time_ago.dart';

//TODO::more button fuctions
class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final TimeAgo timeAgo = TimeAgo();


  @override
  Widget build(BuildContext context) {
    ///Change in case of using API
    return StreamBuilder<SearchList>(
        stream: Provider.of<APIContent>(context).searchResult.stream,
        builder: (context, AsyncSnapshot<SearchList> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.84,
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.active) {
            return Container(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              height: MediaQuery.of(context).size.height * 0.84,
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
                              text: " ?? ",
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
