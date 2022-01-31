import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/provider/api_content.dart';
import 'package:yt_downloader/utils/time_ago.dart';

class VideoDetails extends StatefulWidget {
  final Video video;
  const VideoDetails({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  final TimeAgo _timeAgo = TimeAgo();

  String channelUrl = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChannelUrl(widget.video.channelId.toString());
  }

  void getChannelUrl(String channelId) async {
    var url = await Provider.of<APIContent>(context, listen: false)
        .getChannelURL(widget.video.channelId.toString());
    setState(() {
      channelUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0,left: 4.0,right: 4.0),
      padding: const EdgeInsets.only(bottom: 8.0,left: 4.0,right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.video.title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          space(),
          RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
            text: TextSpan(
              text: displayViews(widget.video.engagement.viewCount.toString()),
              style: const TextStyle(fontSize: 12.0, color: Colors.black87),
              children: <TextSpan>[
                const TextSpan(
                    text: " · ", style: TextStyle(fontWeight: FontWeight.w900)),
                widget.video.uploadDate == null
                    ? const TextSpan(text: 'No Data')
                    : TextSpan(
                        text: _timeAgo.uploadTimeAgo(widget.video.uploadDate!)),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
           Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      channelUrl == ""
                          ? const CircularProgressIndicator()
                          : CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(channelUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AutoSizeText(widget.video.author,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(onTap: null , child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4.0),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent
                    ),
                    child: Row(
                      children: const [
                         Icon(EvaIcons.download,color: Colors.black,),
                         AutoSizeText("Download",maxFontSize: 14, overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  )),
                )

              ],
            ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),



        ],
      ),
    );
  }

  String displayViews(String view) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc;
    mathFunc = (Match match) => '${match[1]},';
    String result = view.replaceAllMapped(reg, mathFunc);
    return result;
  }

  space() {
    return const SizedBox(
      height: 10,
    );
  }
}
