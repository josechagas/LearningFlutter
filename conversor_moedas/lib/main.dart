import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  // final String title;

  final url =
      "https://api.hgbrasil.com/finance"; //https://hgbrasil.com/status/finance

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var getDataFuture;
  final textStyle = TextStyle(color: Colors.white);
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  var _dollar = 1.0;
  var _euro = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFuture = http.get(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    //print(getData());

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("\$Conversor de moedas\$"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: (){
              realController.clear();
              dollarController.clear();
              euroController.clear();
              Focus.of(context).requestFocus(FocusNode());
            },
          )
        ],
      ),
      body: FutureBuilder<http.Response>(
        future: getDataFuture,
        builder: _buildFuture,
      ),
    );
  }

  Future<Map> getData() async {
    http.Response response = await http.get(widget.url);
    return json.decode(response.body);
  }

  Widget _buildFuture(
      BuildContext context, AsyncSnapshot<http.Response> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        break;
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError)
          return _onErrorLoading();
        else if (snapshot.hasData) {
          Map<String, dynamic> jsonData = json.decode(snapshot.data.body);
          var currencies = jsonData["results"]["currencies"];
          var usd = currencies["USD"];
          var eur = currencies["EUR"];

          _dollar = usd["buy"] as double;
          _euro = eur["buy"] as double;
        }
    }
    return _onResult();
  }

  Widget _onErrorLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Ocorreu um erro",
          style: textStyle,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "Recarregar",
          ),
          onPressed: () {
            setState(() {
              getDataFuture = http.get(widget.url);
            });
          },
        )
      ],
    );
  }

  Widget _onResult() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            size: 150,
            color: Theme.of(context).primaryColor,
          ),
          _buildTextField("Real", "R\$", realController,_onRealChange),
          SizedBox(
            height: 10,
          ),
          _buildTextField("Dolar", "US\$", dollarController,_onDollarChange),
          SizedBox(
            height: 10,
          ),
          _buildTextField("Euro", "€", euroController,_onEuroChange),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, String prefixText,
      TextEditingController controller, Function onChange) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: _buildInputDecor(labelText, prefixText),
      style: Theme.of(context).textTheme.title,
      onChanged: onChange,
    );
  }

  InputDecoration _buildInputDecor(String labelText, String prefixText) {
    return InputDecoration(
      labelText: labelText,
      prefixText: prefixText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  void _onRealChange(String value){
    var doubleValue = double.tryParse(value)??0.0;
    euroController.text = (doubleValue/_euro).toStringAsFixed(2);
    dollarController.text = (doubleValue/_dollar).toStringAsFixed(2);
  }

  void _onDollarChange(String value){
    var doubleValue = double.tryParse(value)??0.0;
    var realValue = doubleValue*_dollar;
    realController.text = realValue.toStringAsFixed(2);
    euroController.text = (realValue/_euro).toStringAsFixed(2);
  }

  void _onEuroChange(String value){
    var doubleValue = double.tryParse(value)??0.0;
    var realValue = doubleValue*_euro;
    realController.text = realValue.toStringAsFixed(2);
    dollarController.text = (realValue/_dollar).toStringAsFixed(2);
  }
}
