import 'package:flutter/material.dart';
import 'package:youtube_favorites/resources/youtube_api_provider.dart';
import 'package:youtube_favorites/ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    YoutubeApiProvider().search('teste');

    return MaterialApp(
      title: 'FlutterTube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
