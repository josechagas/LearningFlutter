import 'package:flutter/material.dart';

class LoadInfoWidget extends StatelessWidget {

  LoadInfoWidget({Key key, @required this.hasError,this.onReloadPressed}):super(key: key);

  final Function onReloadPressed;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            hasError ? 'Ocorreu um erro!!!' : 'Nada por aqui!!',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: onReloadPressed != null,
            child: MaterialButton(
              child: Text(
                'Recarregar',
              ),
              onPressed: onReloadPressed,
            ),
          ),
        ],
      ),
    );
  }
}
