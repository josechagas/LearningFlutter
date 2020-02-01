import 'package:flutter/material.dart';
import 'package:lista_contatos/helpers/contact_helper.dart';
import 'package:lista_contatos/ui/contact_page.dart';
import 'package:lista_contatos/ui/my_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

