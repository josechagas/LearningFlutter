import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordTFController = TextEditingController();
  final _emailTFController = TextEditingController();
  final _nameTFController = TextEditingController();
  final _addressTFController = TextEditingController();

  FocusNode _emailNode;
  FocusNode _passwordNode;
  FocusNode _addressNode;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar Conta'
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: _nameTFController,
          decoration: InputDecoration(
            hintText: 'Nome',
            labelText: 'Nome Completo'
          ),
          validator: _validateNotBlank,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _addressNode.requestFocus(),
        ),
        TextFormField(
          focusNode: _addressNode,
          controller: _addressTFController,
          decoration: InputDecoration(
              hintText: 'Rua Exemplo 123, Bairro Legal',
              labelText: 'Endereço'
          ),
          validator: _validateNotBlank,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _emailNode.requestFocus(),
        ),
        TextFormField(
          controller: _emailTFController,
          focusNode: _emailNode,
          decoration: InputDecoration(
            hintText: 'Email',
            labelText: 'Email'
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
          onFieldSubmitted: (_) => _passwordNode.requestFocus(),
        ),
        TextFormField(
          focusNode: _passwordNode,
          controller: _passwordTFController,
          decoration: InputDecoration(
            hintText: 'Senha',
            labelText: 'Senha'
          ),
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

  Widget _buildSignUpButton(){
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
          'Cadastrar',
        ),
        onPressed: _performSignUp,
      ),
    );
  }


  String _validateNotBlank(String text) {
    if(text == null || text.isEmpty)
      return 'Campo inválido!';
    return null;
  }

  String _validateEmail(String email){
    if(email.isEmpty || !email.contains('@'))
      return 'Email inválido';
    return null;
  }

  String _validatePassword(String password){
    if(password.isEmpty)
      return 'Senha inválida!';
    return null;
  }

  void _performSignUp(){
    FocusScope.of(context).unfocus();
    if(_formKey.currentState.validate()) {
      //When Signing up with success its important to pop login page behind this one
      //when pushing the logged page.
    }
  }
}
