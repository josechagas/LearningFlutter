import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/login_page_bloc.dart';
import 'package:virtual_store/router.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _credentialWidgetWidth = 280.0;

  final _passwordTFController = TextEditingController();
  final _emailTFController = TextEditingController();

  FocusNode _emailNode;
  FocusNode _passwordNode;

  final bloc = LoginPageBloc();

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
    bloc.dispose();
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
      body: _buildNormalBody(),
    );
  }

  Widget _buildNormalBody() {
    return SingleChildScrollView(
      child: LimitedBox(
        //to block vertically
        child: Center(
          //to center credentials inside view
          heightFactor: 0.8,
          child: ConstrainedBox(
            constraints:
                BoxConstraints.loose(Size.fromWidth(_credentialWidgetWidth)),
            child: _buildCredentialsWidget(),
          ),
        ),
        maxHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.vertical,
      ),
    );
  }

  Widget _buildCredentialsWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
            validator: (email) {
              if (email.isEmpty || !email.contains('@'))
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
            validator: (password) {
              if (password.isEmpty) return 'Senha inválida!';
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
          _buildLoadActionWidget(),
        ],
      ),
    );
  }

  Widget _buildLoadActionWidget(){
    final avoidClipShadowInset = EdgeInsets.symmetric(vertical: 5, horizontal: 2);
    return ValueListenableBuilder(
      child: Padding(
        padding: avoidClipShadowInset,
        child: _buildSignInButton(),
      ),
      valueListenable: bloc.isLoading,
      builder: (context, isLoading, child) {
        final duration = Duration(milliseconds: 120);
        return AnimatedCrossFade(//clip the childs, making a button to have its shadow clipped.
          firstChild: child,
          secondChild: Container(
            margin: avoidClipShadowInset,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.all(10),
            child: isLoading ? CircularProgressIndicator() : null,
          ),
          duration: duration,
          crossFadeState: isLoading
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        );
      },
    );
  }

  Widget _buildSignInButton() {
    //https://flutter.dev/docs/cookbook/animation/animated-container
    //AnimatedCrossFade(firstChild: null, secondChild: null, crossFadeState: null, duration: null)
    return SizedBox(
      height: 50,
      width: _credentialWidgetWidth,
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
    if (_formKey.currentState.validate()) {
      //perform login
      bloc.performSignIn();
    }
  }

  void _forgotPasswordButtonPressed() {}
}
