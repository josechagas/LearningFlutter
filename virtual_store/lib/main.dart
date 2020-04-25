import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';
import 'package:virtual_store/blocs/login_page_bloc.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/router.dart';
import 'package:virtual_store/ui/home_tab.dart';
import 'package:virtual_store/ui/login_page.dart';
import 'package:virtual_store/ui/my_home_page.dart';

void main() {
  //Intl.defaultLocale = Platform.localeName;
  //await findSystemLocale();
  //runApp(MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserBloc(),
      ),
      ChangeNotifierProxyProvider<UserBloc, CartBloc>(
        create: (_) => CartBloc(),
        update: (_, user, cart)  => cart..didUpdateUserBloc(user),
      ),
      /*ChangeNotifierProvider(
        create: (_) => CartBloc(),
      ),*/
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final rootRouter = RootRouter();
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromARGB(255, 4, 125, 141);
    return MaterialApp(
      title: "Flutter's Clothing",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
      ),
      home: MyHomePage(),
      onGenerateRoute: rootRouter.generateRoute,
    );
  }
}