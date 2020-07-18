import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/blocs/videos_bloc.dart';
import 'package:youtube_favorites/delegates/data_search.dart';
import 'package:youtube_favorites/models/video.dart';
import 'package:youtube_favorites/ui/load_info_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideosBloc>(context).outVideos;
    return Scaffold(
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
          if(snapshot.connectionState == ConnectionState.active ||
          snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (context, index){
                  final video = snapshot.data[index];
                  return _buildVideoListItem(context, video);
                },
                itemCount: snapshot.data.length,
            );
          }

          return LoadInfoWidget(
            hasError: snapshot.hasError,
          );
        },
      ),
    );
  }

  Widget _buildVideoListItem(BuildContext context, Video video) {
    return Container();
  }

  Future<void> startSearch(BuildContext context) async {
    final result = await showSearch(context: context, delegate: DataSearch());
    if(result != null) {
      BlocProvider.of<VideosBloc>(context).inSearch.add(result);
    }
  }
}
