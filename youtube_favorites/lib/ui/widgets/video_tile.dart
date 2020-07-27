import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/blocs/favorite_bloc.dart';
import 'package:youtube_favorites/models/video.dart';

class VideoTile extends StatelessWidget {
  VideoTile(this.video, {Key key}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);
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
  }
}
