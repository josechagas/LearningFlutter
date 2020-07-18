import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/blocs/videos_bloc.dart';
import 'package:youtube_favorites/resources/youtube_api_provider.dart';
import 'package:youtube_favorites/ui/home_page.dart';

void mainDelegate() {
  runApp(MyApp());
}

/*
* "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
*
* */

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    YoutubeApiProvider().search('teste');

    return BlocProvider(
      bloc: VideosBloc(),
      child: MaterialApp(
        title: 'FlutterTube',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
