import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/router.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordTFController = TextEditingController();
  final _emailTFController = TextEditingController();

  FocusNode _emailNode;
  FocusNode _passwordNode;

  @override
  void initState() {
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _passwordTFController.dispose();
    _emailTFController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Entrar',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Criar conta',
            ),
            textColor: Colors.white,
            onPressed: _createAccountButtonPressed,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: LimitedBox(//to block vertically
          child: Center(//to center credentials inside view
            heightFactor: 0.8,
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(Size.fromWidth(280)),
              child: _buildCredentialsWidget(context),
            ),
          ),
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
        ),
      ),
    );
  }

  Widget _buildCredentialsWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _emailTFController,
            focusNode: _emailNode,
            decoration: InputDecoration(
              hintText: 'Email',
              //labelText: 'Email'
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (email){
              if(email.isEmpty || !email.contains('@'))
                return 'Email inválido';
              return null;
            },
            onFieldSubmitted: (_) => _passwordNode.requestFocus(),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            focusNode: _passwordNode,
            controller: _passwordTFController,
            decoration: InputDecoration(
              hintText: 'Senha',
              //labelText: 'Senha'
            ),
            obscureText: true,
            validator: (password){
              if(password.isEmpty)
                return 'Senha inválida!';
              return null;
            },
            onFieldSubmitted: (_) => _signInButtonPressed(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              child: Text(
                'Esqueci a senha',
              ),
              padding: EdgeInsets.zero,
              onPressed: _forgotPasswordButtonPressed,
            ),
          ),
          _buildSignInButton(context),
        ],
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context){
    //https://flutter.dev/docs/cookbook/animation/animated-container
    //AnimatedCrossFade(firstChild: null, secondChild: null, crossFadeState: null, duration: null)
    return SizedBox(
      height: 50,
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Entrar',
        ),
        onPressed: _signInButtonPressed,
      ),
    );
  }

  void _createAccountButtonPressed() {
    Navigator.of(context).pushReplacementNamed(RootRouter.signUp);
  }

  void _signInButtonPressed() {
    if(_formKey.currentState.validate()) {
      //perform login
    }
  }

  void _forgotPasswordButtonPressed(){}
}
