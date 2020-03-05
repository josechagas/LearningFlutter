import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/ui/home_tab.dart';
import 'package:virtual_store/ui/my_home_page.dart';

abstract class Router {
  Route<dynamic> generateRoute(RouteSettings settings);
}

class DrawerRouter implements Router {
  static const String homePage = '/';
  static const String homePage2 = '/homePage2';
  @override
  Route generateRoute(RouteSettings settings) {
    switch (settings.name){
      case homePage: {
        return MaterialPageRoute(
          builder: (context) => HomeTab(),
        );
      }
      case homePage2: {
        return MaterialPageRoute(
          builder: (context) => HomeScreen2(),
        );
      }
      default:
        throw Exception('Unknown route named ${settings.name}');
    }
  }
}

class RootRouter implements Router {
  static const String myHomePage = '/myHomePage';
  @override
  Route generateRoute(RouteSettings settings) {
    switch (settings.name){
      case myHomePage: {
        return MaterialPageRoute(
          builder: (context) => MyHomePage(),
        );
      }
      default:
        throw Exception('Unknown route named ${settings.name}');
    }
  }
}