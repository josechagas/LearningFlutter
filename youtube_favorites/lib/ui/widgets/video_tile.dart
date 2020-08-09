import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_favorites/blocs/favorite_bloc.dart';
import 'package:youtube_favorites/envs.dart';
import 'package:youtube_favorites/models/video.dart';

class VideoTile extends StatelessWidget {
  VideoTile(this.video, {Key key}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);

    return ListTile(
      title: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          video.thumb,
          fit: BoxFit.cover,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      video.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      video.channel,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                )
            ),
            StreamBuilder<Map<String, Video>>(
              stream: bloc.outFav,
              builder: (context, snapshot) {
                final hasFavorite = snapshot.data?.isNotEmpty ?? false;
                final isAFavorite =
                hasFavorite ? snapshot.data.containsKey(video.id) : false;
                return IconButton(
                  icon: Icon(
                    isAFavorite ? Icons.star : Icons.star_border,
                  ),
                  color: Colors.white,
                  disabledColor: Colors.white54,
                  onPressed: () => bloc.toggleFavorite(video),
                );
              },
            )
          ],
        ),
      ),
      onTap: _onVideoTap,
    );

    /*
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              video.thumb,
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder<Map<String, Video>>(
              stream: bloc.outFav,
              builder: (context, snapshot) {
                final hasFavorite = snapshot.data?.isNotEmpty ?? false;
                final isAFavorite =
                    hasFavorite ? snapshot.data.containsKey(video.id) : false;
                return ListTile(
                  isThreeLine: true,
                  title: Text(
                    video.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    video.channel,
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isAFavorite ? Icons.star : Icons.star_border,
                    ),
                    color: Colors.white,
                    disabledColor: Colors.white54,
                    onPressed: () => bloc.toggleFavorite(video),
                  ),
                );
              }),
        ],
      ),
    );

     */
  }

  void _onVideoTap(){
    FlutterYoutube.playYoutubeVideoById(apiKey: Constants.youtubeApiKey, videoId: video.id);
  }

}
