import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        title: Container(
          height: 25,
          child: Image.asset('images/logo.png'),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              '0',
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
            ),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: (){},
          ),
        ],
      ),
      body: Container(),
    );
  }
}
