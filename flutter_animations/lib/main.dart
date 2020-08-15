import 'package:flutter/material.dart';
import 'package:flutter_animations/ui/home_page.dart';
import 'package:flutter_animations/ui/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> _animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    _animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LucasTransition(
          animation: _animation,
          child: LogoWidget(),
        ),
      ],
    );
  }
}

/*
class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo(Animation<double> animation):super(listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> anim = listenable;
    return Center(
      child: Container(
        height: anim.value,
        width: anim.value,
        child: FlutterLogo(),
      ),
    );
  }
}
*/

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class GrowTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  GrowTransition({this.child, this.animation, Key key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child){
          return Container(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
      ),
    );
  }
}


class LucasTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Tween<double> sizeTween = Tween(begin: 0, end: 300);
  final Tween<double> opacityTween = Tween(begin: 0.1, end: 1.0);

  LucasTransition({this.child, this.animation, Key key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child){
          return Container(
            height: sizeTween.evaluate(animation).clamp(0.0, 400.0),
            width: sizeTween.evaluate(animation).clamp(0.0, 400.0),
            child: Opacity(
              opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
