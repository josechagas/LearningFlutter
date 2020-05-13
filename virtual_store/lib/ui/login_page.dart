import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/login_page_bloc.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/router.dart';
import 'package:virtual_store/ui/load_action_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
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
              if (email.isEmpty || !email.contains('@')){
                return 'Email inválido';
              }
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

  Widget _buildLoadActionWidget() {
    return ValueListenableBuilder(
      valueListenable: bloc.isLoading,
      child: Text(
        'Entrar',
      ),
      builder: (context, isLoading, child) {
        return LoadActionButton(
          isLoading: isLoading,
          child: child,
          width: _credentialWidgetWidth,
          height: 50,
          onPressed: _signInButtonPressed,
        );
      },
    );
  }

  Future<SnackBarClosedReason> _showSignInFailedSnackbar() async {
    final snackbar = SnackBar(
      content: Text(
        'Email ou senha inválido!',
      ),
      duration: Duration(seconds: 3),
    );
    final controller = _scaffoldKey.currentState.showSnackBar(snackbar);
    return await controller.closed;
  }

  void _createAccountButtonPressed() {
    Navigator.of(context).pushReplacementNamed(RootRouter.signUp);
  }

  void _signInButtonPressed() {
    if (_formKey.currentState.validate()) {
      final email = _emailTFController.value.text;
      final password = _passwordTFController.value.text;
      //perform login
      bloc.performSignIn(
          email: email,
          password: password,
          onSuccess: _onSignInSuccess,
          onFailure: _onSignInFailure,
      );
    }
  }

  void _onSignInSuccess() {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    userBloc.loadUser();
    Navigator.of(context).pop();
  }

  void _onSignInFailure(Object e) {
    _showSignInFailedSnackbar();
  }

  void _forgotPasswordButtonPressed() {
    String message = 'Confira seu email';
    Color backgroundColor;
    if(_emailTFController.text.isEmpty) {
      message = 'Insira seu email para recuperação!';
      backgroundColor = Colors.redAccent;
    }
    else {
      bloc.recoverPassword(_emailTFController.text);
    }

    final snackbar = SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
