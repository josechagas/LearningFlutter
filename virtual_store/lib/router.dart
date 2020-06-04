import 'package:flutter/material.dart';
import 'package:virtual_store/ui/screens/cart_page.dart';
import 'package:virtual_store/ui/screens/category_detail_page.dart';
import 'package:virtual_store/ui/screens/home_tab.dart';
import 'package:virtual_store/ui/screens/login_page.dart';
import 'package:virtual_store/ui/screens/my_home_page.dart';
import 'package:virtual_store/ui/screens/my_orders_tab.dart';
import 'package:virtual_store/ui/screens/order_page.dart';
import 'package:virtual_store/ui/screens/places_tab.dart';
import 'package:virtual_store/ui/screens/product_page.dart';
import 'package:virtual_store/ui/screens/products_tab.dart';
import 'package:virtual_store/ui/screens/signup_page.dart';

abstract class Router {
  Route<dynamic> generateRoute(RouteSettings settings);
}

class DrawerRouter implements Router {
  static const String homePage = '/';
  static const String myOrders = '/myOrders';
  static const String products = '/products';
  static const String findStore = '/findStore';
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
      case myOrders: {
        return MaterialPageRoute(
          builder: (context) => MyOrdersTab(),
        );
      }
      case findStore: {
        return MaterialPageRoute(
          builder: (context) => PlacesTab(),
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