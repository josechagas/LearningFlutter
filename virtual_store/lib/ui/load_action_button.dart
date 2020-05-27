import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadActionButton extends StatelessWidget {

  LoadActionButton({Key key,@required this.child,@required this.isLoading, this.width = double.infinity, this.height,@required this.onPressed}):super(key: key);

  final bool isLoading;
  final double width;
  final double height;
  final Function onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final avoidClipShadowInset = EdgeInsets.symmetric(vertical: 5, horizontal: 2);
    final duration = Duration(milliseconds: 120);
    final basePaddingValue = 10.0;
    final height = this.height ?? Theme.of(context).buttonTheme.height;
    return AnimatedCrossFade(//clip the childs, making a button have its shadow clipped.
      firstChild: Padding(
        padding: avoidClipShadowInset,
        child: _buildSignInButton(context),
      ),
      secondChild: Container(
        margin: avoidClipShadowInset,
        width: height,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(height/2),
        ),
        padding: EdgeInsets.all(basePaddingValue),
        child: isLoading ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) : null,
      ),
      duration: duration,
      crossFadeState: isLoading
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    //https://flutter.dev/docs/cookbook/animation/animated-container
    //AnimatedCrossFade(firstChild: null, secondChild: null, crossFadeState: null, duration: null)
    return SizedBox(
      height: height,
      width: width,
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: this.child,
        onPressed: onPressed,
      ),
    );
  }

}
