import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/ui/home_page.dart';
import 'package:gerenciamento_loja_online/ui/product_page/product_page.dart';
import 'package:gerenciamento_loja_online/ui/products_page/products_page.dart';

abstract class Router{
  Route<dynamic> generateRoute(RouteSettings settings);
}

class RootRouter implements Router {
  static const homePage = '/homePage';
  static const productPage = '/productPage';

  @override
  Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case homePage:
        builder = (BuildContext _) => HomePage();
        break;
      case productPage:
        final dict = settings.arguments as Map<String,dynamic>;
        builder = (BuildContext _) => ProductPage(categoryId: dict['categoryId'],product: dict['product'],);
        break;
      default:
        throw Exception('RootRouter - Invalid route: ${settings.name}');
    }
    return MaterialPageRoute(builder: builder, settings: settings);
  }
}