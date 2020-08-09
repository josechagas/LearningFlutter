import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/ui/widgets/form_container.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/background.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 200, bottom: 10),
                  child: Image.asset(
                    'images/tickicon.png',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
                FormContainer(),
              ],
            ),
            Positioned(
              left: 40,
              right: 40,
              bottom: 40,
              child: FlatButton(
                child: Text(
                  'Não possui conta? Cadastre-se aqui!',
                ),
                textColor: Colors.white,
                onPressed: (){},
              ),
            )
          ],
        ),
      ),
    );


    return Scaffold(
      body: Container(
        height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 80, bottom: 10),
                      child: Image.asset(
                        'images/tickicon.png',
                        fit: BoxFit.contain,
                        height: 150,
                      ),
                    ),
                    FormContainer(),
                  ],
                ),
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: 40,
                  child: FlatButton(
                    child: Text(
                      'Não possui conta? Cadastre-se aqui!',
                    ),
                    textColor: Colors.white,
                    onPressed: (){},
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
