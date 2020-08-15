import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/login_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class LoginCredentials extends StatefulWidget {
  LoginCredentials(
      {@required this.bloc,
      @required this.usernameController,
      @required this.passwordController,
      Key key})
      : super(key: key);

  final LoginBloc bloc;
  final usernameController;
  final passwordController;

  @override
  _LoginCredentialsState createState() => _LoginCredentialsState();
}

class _LoginCredentialsState extends State<LoginCredentials> {
  GlobalKey<FormFieldState> userFormFieldKey;
  GlobalKey<FormFieldState> passwordFormFieldKey;
  FocusNode usernameFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    userFormFieldKey = GlobalKey();
    passwordFormFieldKey = GlobalKey();
    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Flex(
      direction:
          orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
      children: [
        Expanded(
          child: _buildTextFormFields(
            controller: widget.usernameController,
            key: userFormFieldKey,
            node: usernameFocusNode,
            icon: Icons.person,
            hint: 'Usuário',
            inputType: TextInputType.emailAddress,
            obscureText: false,
            validator: validateUsername,
            onSubmitted: (value) => passwordFocusNode.requestFocus()
          ),
          flex: 10,
        ),
        Spacer(
          flex: 1,
        ),
        Expanded(
          child: _buildTextFormFields(
            controller: widget.passwordController,
            key: passwordFormFieldKey,
            node: passwordFocusNode,
            icon: Icons.lock,
            hint: 'Senha',
            inputType: TextInputType.text,
            obscureText: true,
            validator: validatePassword,
          ),
          flex: 10,
        ),
      ],
    );
  }

  Widget _buildTextFormFields({
    @required IconData icon,
    @required String hint,
    @required TextInputType inputType,
    bool obscureText = false,
    TextEditingController controller,
    GlobalKey<FormFieldState> key,
    FocusNode node,
    String Function(String) validator,
    void Function(String) onSubmitted,
  }) {
    final textsStyle = TextStyle(color: Colors.white);
    return TextFormField(
      controller: controller,
      key: key,
      focusNode: node,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        hintText: hint,
        hintStyle: textsStyle,
      ),
      style: textsStyle,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      onChanged: (newValue) {
        key.currentState.validate();
        _fireEventToUpdateState();
      },
      onFieldSubmitted: onSubmitted,
      validator: validator,
    );
  }

  void _fireEventToUpdateState() {
    final isValid = userFormFieldKey.currentState.isValid &&
        passwordFormFieldKey.currentState.isValid;
    final event = isValid
        ? LoginBlocEvents.credentialsValidFormat
        : LoginBlocEvents.credentialsInvalidFormat;
    widget.bloc.add(BlocEvent(event));
  }

  String validateUsername(String value) {
    if (value == null || value.isEmpty) {
      return 'Campo Usuário é obrigatório';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value == null || value.length < 4) {
      return 'Precisa ter no minímo 4 caracteres';
    }
    return null;
  }
}
