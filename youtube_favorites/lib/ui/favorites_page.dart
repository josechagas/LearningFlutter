import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/blocs/favorite_bloc.dart';
import 'package:youtube_favorites/models/video.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritos',
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String,Video>>(
        stream: bloc.outFav,
        builder: (context, snapshot){
          final videos = snapshot.data?.values?.toList() ?? [];
          return ListView.builder(
            itemCount: videos.length,
              itemBuilder: (context, index){
                final video = videos[index];
                return InkWell(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 50,
                        child: Image.network(video.thumb),
                      ),
                      Expanded(
                        child: Text(
                          video.title,
                          style: TextStyle(color: Colors.white70),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  onTap: (){},
                  onLongPress: (){
                    bloc.toggleFavorite(video);
                  },
                );
              },);
        },
      ),
    );
  }
}
