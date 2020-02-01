import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Pessoas',
      theme: ThemeData(primaryColor: Colors.blueAccent),
      darkTheme: ThemeData(primaryColor: Colors.blueGrey),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState({this.peopleCount = 0, this.maxPeople = 11}):super();

  int peopleCount;
  int maxPeople;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/restaurante.jpg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: _buildBody(),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    var mainTextStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Pessoas: $peopleCount",
          style: mainTextStyle,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _buildButtons(),
        ),
        Text(
          _textForBottomTextView(),
          style: mainTextStyle,
        )
      ],
    );
  }

  Widget _buildButtons() {
    var buttonTextStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text(
            "+1",
            style: buttonTextStyle,
          ),
          onPressed: _addPerson,
        ),
        FlatButton(
          child: Text(
            "-1",
            style: buttonTextStyle,
          ),
          onPressed: _rmPerson,
        ),
      ],
    );
  }

  String _textForBottomTextView(){
    if(peopleCount < 0) {
      return "Mundo invertido?!";
    }
    else if(peopleCount < maxPeople) {
      return "Pode entrar!";
    }
    else {
      return "Está lotado!!!";
    }
  }

  void _addPerson() {
    if(peopleCount < maxPeople) {
      setState(() {
        peopleCount++;
      });
    }
  }
  void _rmPerson() {
    setState(() {
      peopleCount--;
    });
  }
}
