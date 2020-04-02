import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/ui/category_detail_page.dart';
import 'package:virtual_store/ui/home_tab.dart';
import 'package:virtual_store/ui/my_home_page.dart';
import 'package:virtual_store/ui/products_tab.dart';

abstract class Router {
  Route<dynamic> generateRoute(RouteSettings settings);
}

class DrawerRouter implements Router {
  static const String homePage = '/';
  static const String homePage2 = '/homePage2';
  static const String products = '/products';
  @override
  Route generateRoute(RouteSettings settings) {
    switch (settings.name){
      case homePage: {
        return MaterialPageRoute(
          builder: (context) => HomeTab(),
        );
      }
      case products: {
        return MaterialPageRoute(
          builder: (context) => ProductsTab(),
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
  static const String categoryDetail = '/categoryDetail';

  @override
  Route generateRoute(RouteSettings settings) {
    switch (settings.name){
      case myHomePage: {
        return MaterialPageRoute(
          builder: (context) => MyHomePage(),
        );
      }
      case categoryDetail: {
        return MaterialPageRoute(
          builder: (context) => CategoryDetailPage(categorySnapshot: settings.arguments,),
        );
      }
      default:
        throw Exception('Unknown route named ${settings.name}');
    }
  }
}