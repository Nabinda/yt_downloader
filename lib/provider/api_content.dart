import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';

class APIContent extends ChangeNotifier {

  static String apiKey = "";
  final YoutubeAPI _youtube = YoutubeAPI(apiKey, maxResults: 20);
  List<YouTubeVideo> searchResult = [];
  bool isSearch = false;

  Future<void> searchVideo(String searchQuery) async {
    searchResult = await _youtube.search(searchQuery,
        order: 'relevance', regionCode: 'NP');
    searchResult = await _youtube.nextPage();
    notifyListeners();
  }

  List<YouTubeVideo> getVideo() {
    return searchResult;
  }

  bool getSearchStatus(){
    return isSearch;
  }
  void toggleSearch(){
    isSearch = !isSearch;
    notifyListeners();
  }
}
