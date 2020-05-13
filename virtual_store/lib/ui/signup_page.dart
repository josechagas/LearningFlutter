import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/signup_page_bloc.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/ui/load_action_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _passwordTFController = TextEditingController();
  final _emailTFController = TextEditingController();
  final _nameTFController = TextEditingController();
  final _addressTFController = TextEditingController();

  FocusNode _emailNode;
  FocusNode _passwordNode;
  FocusNode _addressNode;

  final bloc = SignUpPageBloc();

  @override
  void initState() {
    _addressNode = FocusNode();
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
    _nameTFController.dispose();
    _addressNode.dispose();
    _addressTFController.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar Conta'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: _nameTFController,
          decoration:
              InputDecoration(hintText: 'Nome', labelText: 'Nome Completo'),
          validator: _validateNotBlank,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _addressNode.requestFocus(),
        ),
        TextFormField(
          focusNode: _addressNode,
          controller: _addressTFController,
          decoration: InputDecoration(
              hintText: 'Rua Exemplo 123, Bairro Legal', labelText: 'Endereço'),
          validator: _validateNotBlank,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _emailNode.requestFocus(),
        ),
        TextFormField(
          controller: _emailTFController,
          focusNode: _emailNode,
          decoration: InputDecoration(hintText: 'Email', labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
          onFieldSubmitted: (_) => _passwordNode.requestFocus(),
        ),
        TextFormField(
          focusNode: _passwordNode,
          controller: _passwordTFController,
          decoration: InputDecoration(hintText: 'Senha', labelText: 'Senha'),
          obscureText: true,
          validator: _validatePassword,
          onFieldSubmitted: (_) => _performSignUp(),
        ),
        SizedBox(
          height: 20,
        ),
        _buildSignUpButton()
      ],
    );
  }

  Widget _buildSignUpButton() {
    //https://flutter.dev/docs/cookbook/animation/animated-container
    //AnimatedCrossFade(firstChild: null, secondChild: null, crossFadeState: null, duration: null)
    return ValueListenableBuilder(
        valueListenable: bloc.isLoading,
        child: Text(
          'Cadastrar',
        ),
        builder: (context, isLoading, child) {
          return LoadActionButton(
            isLoading: isLoading,
            child: child,
            onPressed: _performSignUp,
          );
        });
  }

  Future<SnackBarClosedReason> _showSuccessSnackbar() async {
    final snackbar = SnackBar(
      content: Text(
        'Usuário criado com sucesso!',
      ),
      duration: Duration(seconds: 3),
    );
    final controller = _scaffoldKey.currentState.showSnackBar(snackbar);
    return await controller.closed;
  }

  String _validateNotBlank(String text) {
    if (text == null || text.isEmpty) return 'Campo inválido!';
    return null;
  }

  String _validateEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return 'Email inválido';
    return null;
  }

  String _validatePassword(String password) {
    if (password.isEmpty) return 'Senha inválida!';
    if (password.length < 6){
      return 'A senha deve conter no minimo 6 caracteres!';
    }
    return null;
  }

  void _performSignUp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      //When Signing up with success its important to pop login page behind this one
      //when pushing the logged page.

      bloc.performSignUp(
          name: _nameTFController.value.text,
          address: _addressTFController.value.text,
          email: _emailTFController.value.text,
          password: _passwordTFController.value.text,
          onSuccess: _onSignUpSuccess,
          onFailure: _onSignUpFailure);
    }
  }

  void _onSignUpSuccess() async {
    final _ = await _showSuccessSnackbar();
    final bloc = Provider.of<UserBloc>(context,listen: false);
    unawaited(//accordingly to pendantic
        bloc.loadUser()
    );
    Navigator.of(context).pop();
  }

  void _onSignUpFailure(Object obj) {
    print(obj);
    String message = 'Ocorreu um erro durante o cadastro.';
    PlatformException e = obj as PlatformException;
    if(e != null) {
      switch(e.code) {
        case 'ERROR_WEAK_PASSWORD':
          message = 'A senha informada é muito fraca.\n\n${e.message}';
          break;
        case 'ERROR_INVALID_EMAIL':
          message = 'O email informado é inválido.\n\n${e.message}';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          message = 'O email informado já está em uso.\n\n${e.message}';
          break;
        default:
          break;
      }
    }

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
          'Cadastro Falhou',
        ),
        content: Text(
            message,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'OK'
            ),
            onPressed: ()=> Navigator.of(context).pop(),
          ),
        ],
      );
    });
  }
}
