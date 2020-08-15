import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/ui/home_page.dart';
import 'package:flutter_animations/ui/widgets/form_container.dart';
import 'package:flutter_animations/ui/widgets/stagger_animation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  with SingleTickerProviderStateMixin {

  AnimationController _animController;

  @override
  void initState() {
    _animController =  AnimationController(
        vsync: this,
      duration: Duration(seconds: 2),
    );
    _animController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment(0,0.3),
          children: <Widget>[
            Image.asset(
              'images/background.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/tickicon.png',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormContainer(),
                ],
              ),
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
            ),
            StaggerAnimation(
              controller: _animController,
            ),
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
