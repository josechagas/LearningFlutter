import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_favorites/models/video.dart';

class FavoriteBloc implements BlocBase {

  FavoriteBloc(){
    loadFavorites();
  }

  Map<String, Video> _favorites = {};
  final _favController = BehaviorSubject<Map<String,Video>>(seedValue: {});
  Stream<Map<String,Video>> get outFav {
    return _favController.stream;
  }

  @override
  void dispose() {
    _favController.close();
  }

  void toggleFavorite(Video video) {
    if(_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    }
    else {
      _favorites[video.id] = video;
    }
    _favController.sink.add(_favorites);
    saveFavorites();
  }

  void loadFavorites(){
    SharedPreferences.getInstance().then((prefs) {
      if(prefs.getKeys().contains('favorites')){
        _favorites = json.decode(prefs.getString('favorites')).map((key, value){
          return MapEntry(key,Video.fromJson(value));
        }).cast<String,Video>();

        _favController.add(_favorites);
      }
    });
  }

  void saveFavorites(){
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('favorites', json.encode(_favorites));
    });
  }
}