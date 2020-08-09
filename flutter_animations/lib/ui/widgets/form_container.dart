import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildCredentialsFormField(
              hint: 'Email',
              icon:  Icons.person,
            ),
            SizedBox(height: 10,),
            _buildCredentialsFormField(
              hint: 'Senha',
              icon: Icons.lock,
              obscureText: true
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsFormField({@required IconData icon, @required String hint, bool obscureText}){
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        icon: Icon(
          icon,
        ),
        hintText: hint,
      ),
      obscureText: obscureText ?? false,
    );
  }
}
