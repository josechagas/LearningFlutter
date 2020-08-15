import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({this.controller, Key key})
      : buttonSqueeze = Tween(begin: 320.0, end: 60.0).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(
                  0, 0.150) //define quando comeca e quando termina em %
              ),
        ),
        buttonZoomOut = Tween(begin: 0.0, end:1.0).animate(
          CurvedAnimation( 
            parent: controller,
            curve: Interval(0.5, 1, curve: Curves.fastLinearToSlowEaseIn),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    final zoomOutHeight = buttonZoomOut.value*MediaQuery.of(context).size.height;
    final zoomOutWidth = buttonZoomOut.value*MediaQuery.of(context).size.width;
    final zoomSide = zoomOutWidth < zoomOutHeight ? zoomOutHeight : zoomOutWidth;

    return InkWell(
      child: Hero(
        child: zoomOutHeight <= 60
            ? Container(
          width: buttonSqueeze.value,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(247, 64, 106, 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: _buildInside(context),
        )
            : Container(
          width: zoomSide,
          height: zoomSide,
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 64, 106, 1),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*buttonZoomOut.value)
          ),
        ),
        tag: 'fade',
      ),
      onTap: () {
        controller.forward();
      },
    );
  }

  Widget _buildInside(BuildContext context) {
    if (buttonSqueeze.value > 75) {
      return Text(
        'Sign in',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 1,
      );
    }
  }
}
