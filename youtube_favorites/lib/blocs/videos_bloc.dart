
import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_favorites/models/video.dart';
import 'package:youtube_favorites/resources/youtube_api_provider.dart';

class VideosBloc implements BlocBase {
  final youtubeApi = YoutubeApiProvider();
  final StreamController<List<Video>> _videosController = StreamController();
  final StreamController<String> _searchController = StreamController();

  Stream<List<Video>> get outVideos => _videosController.stream;
  Sink<String> get inSearch => _searchController.sink;

  List<Video> videos;

  VideosBloc(){
    _searchController.stream.listen(_performSearch);
  }

  void _performSearch(String search) async {
    if(search != null) {
      _videosController.sink.add([]);
      videos = await youtubeApi.search(search);
    }
    else {
      videos += await youtubeApi.nextPage();
    }
    _videosController.sink.add(videos);
    print(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

}