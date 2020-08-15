import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;
    final windowSize = MediaQuery.of(context).size;
    final credentialsMaxWidth = 280.0*(orientation == Orientation.portrait ? 1 : 2);
    final calculateHorizontalPadding = windowSize.width > credentialsMaxWidth ? (windowSize.width - credentialsMaxWidth)/2.0 : 20;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: windowSize.width,
          height: windowSize.height,
          color: Colors.black54,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: calculateHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: orientation == Orientation.portrait ? 5 : 1,
              ),
              Visibility(
                visible: Orientation.portrait == orientation,
                child: Icon(
                  Icons.home,
                  size: 120,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _buildTextFormFields(
                icon: Icons.person,
                hint: 'Usuário',
                inputType: TextInputType.emailAddress,
                obscureText: false,
              ),
              _buildTextFormFields(
                icon: Icons.lock,
                hint: 'Senha',
                inputType: TextInputType.text,
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: RaisedButton(
                  child: Text(
                    'Entrar',
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  disabledColor: Theme.of(context).primaryColor.withAlpha(180),
                  onPressed: (){},
                ),
              ),
              Spacer(
                flex: 9,
              ),
              MaterialButton(
                child: Text(
                    'Não tem conta? Cadastrar-se aqui!'
                ),
                textColor: Colors.white,
                onPressed: (){},
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _buildTextFormFields({@required IconData icon, @required String hint, @required TextInputType inputType, bool obscureText = false}){
    final textsStyle = TextStyle(
        color: Colors.white
    );
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        hintText: hint,
        hintStyle: textsStyle,
      ),
      style: textsStyle,
      obscureText: obscureText,
    );
  }
}
