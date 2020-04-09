import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:virtual_store/router.dart';
import 'package:virtual_store/ui/home_tab.dart';
import 'package:virtual_store/ui/my_home_page.dart';

void main() {
  //Intl.defaultLocale = Platform.localeName;
  //await findSystemLocale();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final rootRouter = RootRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter's Clothing",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141),
      ),
      home: MyHomePage(),
      onGenerateRoute: rootRouter.generateRoute,
    );
  }
}