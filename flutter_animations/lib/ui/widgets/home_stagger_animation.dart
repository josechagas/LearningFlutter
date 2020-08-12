import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/ui/widgets/home_top.dart';

class HomeStaggerAnimation extends StatelessWidget {

  HomeStaggerAnimation({this.controller, Key key}):
        _containerGrow = CurvedAnimation(parent: controller,curve: Curves.ease),
        super(key: key);

  final AnimationController controller;
  final Animation<double> _containerGrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(
          animation: controller,
          builder: _buildAnimation,
        ),
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child){
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        HomeTop(
          containerGrow: _containerGrow,
        ),
      ],
    );
  }
}
