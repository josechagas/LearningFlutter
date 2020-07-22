import 'package:flutter/material.dart';
import 'package:youtube_favorites/models/video.dart';

class VideoTile extends StatelessWidget {

  VideoTile(this.video,{Key key}):super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16/9,
            child: Image.network(
                video.thumb,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            isThreeLine: true,
            title: Text(
              video.title,
              style: TextStyle(
                color: Colors.white
              ),
            ),
            subtitle: Text(
              video.channel,
              style: TextStyle(
                  color: Colors.white70
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.star_border,
              ),
              color: Colors.white,
              disabledColor: Colors.white54,
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
  }
}
