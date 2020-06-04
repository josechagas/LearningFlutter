import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/router.dart';

class UserNotLoggedInfoWidget extends StatelessWidget {

  UserNotLoggedInfoWidget({Key key, @required this.icon, @required this.message}):super(key: key);

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text('Entrar'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () => _goToLoginPage(context),
          ),
        ],
      ),
    );
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(RootRouter.signIn);
  }
}
