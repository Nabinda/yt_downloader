import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_api/youtube_api.dart';
import '/provider/api_content.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    final videoResult = Provider.of<APIContent>(context,listen:false).getVideo();
    return Container(
      padding: const EdgeInsets.only(top: 10,bottom: 30),
      height: MediaQuery.of(context).size.height*0.84,
      child: ListView(
        children: videoResult.map<Widget>(listItem).toList(),
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return Card(
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
                    video.thumbnail.small.url ?? '',
                    width: MediaQuery.of(context).size.width*0.35,
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5.0,right: 5.0),
                          padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5.0),
                          color: Colors.black,
                          child: Text(int.tryParse(video.duration!)!=null?"0:"+video.duration!
                              :video.duration!,style: const TextStyle(color: Colors.white,fontSize: 12),)))
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    video.title.replaceAll('&quot;', "'"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    video.channelTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: const TextStyle(fontSize: 12.0,color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    video.description!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    style: const TextStyle(fontSize: 12.0,color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
