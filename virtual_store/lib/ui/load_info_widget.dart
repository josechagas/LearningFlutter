import 'package:flutter/material.dart';

class LoadInfoWidget extends StatelessWidget {

  LoadInfoWidget({Key key, @required this.hasError}):super(key: key);

  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            hasError ? 'Ocorreu um erro!!!' : 'Nada por aqui!!',
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            child: Text(
              'Recarregar',
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
