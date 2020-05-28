import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/ui/cart_page.dart';
import 'package:virtual_store/ui/category_detail_page.dart';
import 'package:virtual_store/ui/home_tab.dart';
import 'package:virtual_store/ui/login_page.dart';
import 'package:virtual_store/ui/my_home_page.dart';
import 'package:virtual_store/ui/order_page.dart';
import 'package:virtual_store/ui/product_page.dart';
import 'package:virtual_store/ui/products_tab.dart';
import 'package:virtual_store/ui/signup_page.dart';

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
  static const String productDetail = '/productDetail';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String cartPage = '/cartPage';
  static const String orderPage = '/orderPage';

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
      case productDetail: {
        return MaterialPageRoute(
          builder: (context) => ProductPage(product: settings.arguments,),
        );
      }
      case signUp: {
        return MaterialPageRoute(
          builder: (context) => SignUpPage(),
        );
      }
      case signIn: {
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      }
      case cartPage: {
        return MaterialPageRoute(
          builder: (context) => CartPage(),
        );
      }
      case orderPage: {
        return MaterialPageRoute(
          builder: (context) => OrderPage(orderId: settings.arguments,),
        );
      }
      default:
        throw Exception('Unknown route named ${settings.name}');
    }
  }
}