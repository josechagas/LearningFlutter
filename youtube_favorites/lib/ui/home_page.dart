import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/blocs/favorite_bloc.dart';
import 'package:youtube_favorites/blocs/videos_bloc.dart';
import 'package:youtube_favorites/delegates/data_search.dart';
import 'package:youtube_favorites/models/video.dart';
import 'package:youtube_favorites/ui/load_info_widget.dart';
import 'package:youtube_favorites/ui/widgets/video_tile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideosBloc>(context);
    final favoritesBloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        title: Container(
          height: 25,
          child: Image.asset('images/logo.png'),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String,Video>>(
              stream: favoritesBloc.outFav,
              builder: (context, snapshot){
                return Text(
                  '${snapshot.data?.length ?? 0}',
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
            ),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: (){
              startSearch(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Video>>(
        stream: bloc.outVideos,
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (context, index){
                  if(index < snapshot.data.length) {
                    final video = snapshot.data[index];
                    return VideoTile(video);
                  }
                  else if(index > 1){
                    bloc.inSearch.add(null);//add a null search string to fire the listen method '_performSearch' in mode to load next page.
                    return Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
                itemCount: snapshot.data.length + 1,
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> startSearch(BuildContext context) async {
    final result = await showSearch(context: context, delegate: DataSearch());
    if(result != null) {
      BlocProvider.of<VideosBloc>(context).inSearch.add(result);
    }
  }
}
