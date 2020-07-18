import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/blocs/videos_bloc.dart';
import 'package:youtube_favorites/delegates/data_search.dart';
import 'package:youtube_favorites/models/video.dart';
import 'package:youtube_favorites/ui/load_info_widget.dart';
import 'package:youtube_favorites/ui/widgets/video_tile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideosBloc>(context).outVideos;
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
            child: Text(
              '0',
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
        stream: bloc,
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (context, index){
                  final video = snapshot.data[index];
                  return VideoTile(video);
                },
                itemCount: snapshot.data.length,
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
