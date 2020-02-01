import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final mainColor = Colors.green;
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  double imc;

  @override
  Widget build(BuildContext context) {
    var formChild = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          Icons.person_outline,
          size: 120.0,
          color: mainColor,
        ),
        _buildWeightTextField(),
        _buildHeightTextField(),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 50.0,
          child: RaisedButton(
            textColor: Colors.white,
            color: mainColor,
            child: Text(
              "Calcular IMC",
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _calculateIMC();
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            _bottomText(),
            style: textFieldsTextStyle(),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _resetButtonAction,
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              child: formChild,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textFieldsTextStyle() =>
      TextStyle(color: mainColor, fontSize: 25.0);

  Widget _buildWeightTextField() {
    return TextFormField(
      controller: weightController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Peso (kg)", labelStyle: TextStyle(color: mainColor)),
      textAlign: TextAlign.center,
      style: textFieldsTextStyle(),
      validator: _weightTFValidator,
    );
  }

  Widget _buildHeightTextField() {
    return TextFormField(
      controller: heightController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Altura (cm)", labelStyle: TextStyle(color: mainColor)),
      textAlign: TextAlign.center,
      style: textFieldsTextStyle(),
      validator: _heightTFValidator,
    );
  }

  String _weightTFValidator(String value) {
    double weight = double.tryParse(value);
    if (value.isEmpty || weight == null) {
      return "Insira seu peso!";
    } else if (weight <= 0) {
      return "Insira um peso válido!";
    }
    return null;
  }

  String _heightTFValidator(String value) {
    double height = double.tryParse(value);
    if (value.isEmpty || height == null) {
      return "Insira sua altura!";
    } else if (height <= 0) {
      return "Insira uma altura válida!";
    }
    return null;
  }

  String _bottomText() {
    if (imc != null) {
      var imcString = imc.toStringAsPrecision(4);
      if (imc >= 18.6 && imc < 24.9) {
        return "Peso ideal ($imcString)";
      } else if (imc >= 24.9 && imc < 29.9) {
        return "Levemente acima do peso ($imcString)";
      } else if (imc >= 29.9 && imc < 34.9) {
        return "Obesidade Grau 1 ($imcString)";
      } else if (imc >= 34.9 && imc < 39.9) {
        return "Obesidade Grau 2 ($imcString)";
      } else if (imc >= 40) {
        return "Obesidade Grau 3 ($imcString)";
      } else {
        //if(imc < 18.6)
        return "Abaixo do peso ($imcString)";
      }
    }
    return "Informe seus dados!";
  }

  void _calculateIMC() {
    var weight = double.tryParse(weightController.text) ?? 0.0;
    var height = (double.tryParse(heightController.text) ?? 0.0) /
        100.0; // its in cm so x/100 meters

    setState(() {
      this.imc = weight / pow(height, 2);
    });
  }

  void _resetButtonAction() {
    setState(() {
      imc = null;
      _formKey.currentState?.reset();
    });
    weightController.clear();
    heightController.clear();
    FocusScope.of(context).unfocus(); // dismiss the keyboard.
  }
}
