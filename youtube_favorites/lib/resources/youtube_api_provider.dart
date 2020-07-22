import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_favorites/envs.dart';
import 'package:youtube_favorites/models/video.dart';


class YoutubeApiProvider {
  YoutubeApiProvider();

  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _nextToken = null;
    _search = search;
    final type = 'video';
    final maxResults = 10;
    String url =
        'https://www.googleapis.com/youtube/v3/search?'
        'part=snippet&'
        'q=$search&'
        'type=$type&'
        'key=${Constants.youtubeApiKey}&'
        'maxResults=$maxResults';
    http.Response response = await http.get(url);
    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    final type = 'video';
    final maxResults = 10;
    String url =
        'https://www.googleapis.com/youtube/v3/search?'
        'part=snippet&'
        'q=$_search&'
        'type=$type&'
        'key=${Constants.youtubeApiKey}&'
        'maxResults=$maxResults&pageToken=$_nextToken';
    http.Response response = await http.get(url);
    return decode(response);
  }

  List<Video> decode(http.Response response){
    if(response.statusCode == 200) {
      final decodedMap = json.decode(response.body);
      _nextToken = decodedMap['nextPageToken'];
      final listItems = decodedMap['items'];
      List<Video> videos = listItems.map<Video>(
          (item){
            return Video.fromJson(item);
          }
      ).toList();
      return videos;
    }
    else {
      throw('Could not decode videos');
    }
  }

}
