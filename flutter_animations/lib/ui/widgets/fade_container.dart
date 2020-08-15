import 'package:flutter/material.dart';

class FadeContainer extends StatelessWidget {

  FadeContainer({@required this.animation, Key key}):super(key: key);

  final Animation<Color> animation;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fade',
      child: Container(
        decoration: BoxDecoration(
          color: animation.value,
        ),
      ),
    );
  }
}
