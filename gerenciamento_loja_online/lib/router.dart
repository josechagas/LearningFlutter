import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/ui/home_page.dart';

abstract class Router{
  Route<dynamic> generateRoute(RouteSettings settings);
}

class RootRouter implements Router {
  static const homePage = '/homePage';
  static const loginPage = '/loginPage';
  static const registerPage = '/registerPage';

  @override
  Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case homePage:
        builder = (BuildContext _) => HomePage();
        break;
      /*case loginPage:
        builder = (BuildContext _) => LoginPage();
        break;
      case registerPage:
        builder = (BuildContext _) => RegisterPage();
        break;*/
      default:
        throw Exception('RootRouter - Invalid route: ${settings.name}');
    }
    return MaterialPageRoute(builder: builder, settings: settings);
  }
}