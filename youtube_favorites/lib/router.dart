
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/ui/favorites_page.dart';
import 'package:youtube_favorites/ui/home_page.dart';

abstract class Router{
  Route<dynamic> generateRoute(RouteSettings settings);
}

class RootRouter extends Router {
  static const favorites = 'favorites';

  @override
  Route generateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch(settings.name) {
      case(favorites):{
        builder = (context)=> FavoritesPage();
        break;
      }
      default:
        throw Exception('RootRouter Unrecognized route: ${settings.name}');
    }

    return MaterialPageRoute(builder: builder);
  }
}
