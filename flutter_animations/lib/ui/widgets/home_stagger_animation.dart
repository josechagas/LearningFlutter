import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/ui/widgets/animated_listview.dart';
import 'package:flutter_animations/ui/widgets/fade_container.dart';
import 'package:flutter_animations/ui/widgets/home_top.dart';

class HomeStaggerAnimation extends StatelessWidget {

  HomeStaggerAnimation({this.controller, Key key}):
        _containerGrow = CurvedAnimation(parent: controller,curve: Curves.ease),
        _listSlidePosition = Tween(
            begin: 0.0,
            end: 90.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.325,0.8, curve: Curves.ease),
          ),
        ),
        _fadeAnimation = ColorTween(
            begin: Color.fromRGBO(247, 64, 106, 1),
            end: Color.fromRGBO(247, 64, 106, 0)
        ).animate(
          CurvedAnimation(
            curve: Curves.decelerate,
            parent: controller,
          )
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> _containerGrow;
  final Animation<double> _listSlidePosition;
  final Animation<Color> _fadeAnimation;
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
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            HomeTop(
              containerGrow: _containerGrow,
            ),
            AnimatedListView(
              animation: _listSlidePosition,
            ),
          ],
        ),
        IgnorePointer(
          child: FadeContainer(
            animation: _fadeAnimation,
          ),
        )
      ],
    );
  }
}
