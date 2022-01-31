import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' show Client;

class APIContent extends ChangeNotifier {
  static String apiKey = "AIzaSyCB62K8P4Nr-OXwGLqYcyJjzzDhzYya49w";
  Client httpClient = Client();
  //static String apiKey = "AIzaSyC-aSEHNVi-3bJJ5-39165fc6-Z4QdO9NI";
  final YoutubeExplode yt = YoutubeExplode();
  BehaviorSubject<SearchList> _searchResult = BehaviorSubject<SearchList>();

  searchVideo(String searchQuery) async {
    var result = await yt.search
        .getVideos(searchQuery, filter: const SearchFilter('EgIQAQ%253D%253D'));
    result.nextPage();
    _searchResult.sink.add(result);
  }

  clearSearch() {
    //_searchResult = BehaviorSubject<List<YouTubeVideo>>();
    _searchResult = BehaviorSubject<SearchList>();
    notifyListeners();
  }

  //BehaviorSubject<List<YouTubeVideo>> get searchResult => _searchResult;
  BehaviorSubject<SearchList> get searchResult => _searchResult;

  Future<String> getChannelURL(String channelId) async {
    var apiURL =
        "https://www.googleapis.com/youtube/v3/channels?part=snippet&fields=items%2Fsnippet%2Fthumbnails%2Fdefault&id=$channelId&key=$apiKey";
    final response = await httpClient.get(Uri.parse(apiURL));
    if (response.statusCode != 200) {
      return 'Error';
    }
    final json = jsonDecode(response.body);
    String channelURl =
        json['items'][0]['snippet']['thumbnails']['default']['url'];
    return channelURl;
  }

  BehaviorSubject<List<Video>> _similarVideos = BehaviorSubject<List<Video>>();

  retriveSimilarVideos(String videoId) async {
    String maxResults = '11';
    List<Video> _relatedVideo = <Video>[];
    var apiURL =
        'https://youtube.googleapis.com/youtube/v3/search?part=snippet&relatedToVideoId=$videoId&type=video&maxResults=$maxResults&key=$apiKey';
    print(apiURL);
    final response = await httpClient.get(Uri.parse(apiURL));
    if (response.statusCode != 200) {
      return 'Error';
    }
    final json = jsonDecode(response.body);
    final data = json['items'];
    int dataSize = json['pageInfo']['resultsPerPage'];
    for (int i = 1; i < dataSize; i++) {
      final videoId = data[i]['id']['videoId'];
      Video video = await yt.videos.get(videoId);
      _relatedVideo.add(video);
    }
    _similarVideos.sink.add(_relatedVideo);
  }

  clearSimilarSearch() {
    _similarVideos = BehaviorSubject<List<Video>>();
    notifyListeners();
  }

  BehaviorSubject<List<Video>> get similarVideos => _similarVideos;
}
