
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/login_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';
import 'package:gerenciamento_loja_online/router.dart';
import 'package:gerenciamento_loja_online/ui/login_page/login_credentials.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final LoginBloc bloc = LoginBloc(
      LoginBlocState(
          enableSignInButton: false
      ),
  );

  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;
    final windowSize = MediaQuery.of(context).size;
    final credentialsMaxWidth = 280.0*(orientation == Orientation.portrait ? 1 : 2);
    final calculateHorizontalPadding = windowSize.width > credentialsMaxWidth ? (windowSize.width - credentialsMaxWidth)/2.0 : 20;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: windowSize.width,
          height: windowSize.height,
          color: Colors.grey[850],
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: calculateHorizontalPadding),
          child: BlocListener<LoginBloc,LoginBlocState>(
            cubit: bloc,
            listenWhen: (previousState, newState)=> previousState.signInStatus != newState.signInStatus && newState.signInStatus != LoginStatus.none,
            listener: _onBlocStateUpdateListener,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(
                  flex: 1,
                ),
                Visibility(
                  visible: Orientation.portrait == orientation,
                  child: Icon(
                    Icons.home,
                    size: 120,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 1,
                  child: LoginCredentials(
                    bloc: bloc,
                    usernameController: usernameController,
                    passwordController: passwordController,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<LoginBloc, LoginBlocState>(
                  cubit: bloc,
                  builder: (context, state){
                    return state.signInStatus == LoginStatus.performing ?
                    Center(
                      child: CircularProgressIndicator(),
                    )
                    : SizedBox(
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          'Entrar',
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor.withAlpha(180),
                        onPressed: state.enableSignInButton ? onPerformSignInButtonPressed : null,
                      ),
                    );
                  },
                ),
                Spacer(
                  flex: 1,
                ),
                MaterialButton(
                  child: Text(
                      'Não tem conta? Cadastrar-se aqui!'
                  ),
                  textColor: Colors.white,
                  onPressed: (){},
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  void _onBlocStateUpdateListener(BuildContext context, LoginBlocState state){
    switch(state.signInStatus) {
      case LoginStatus.performing:
        break;
      case LoginStatus.successfull:
        Navigator.of(context).pushReplacementNamed(RootRouter.homePage);
        break;
      case LoginStatus.errorInvalidCredentials:
        _showInvalidCredentialsAlert();
        break;
      case LoginStatus.errorVerifyConnection:
        _showVerifyConnectionAlert();
        break;
      case LoginStatus.noPermissions:
        _showNoPermissionAlert();
        break;
      default:
        break;
    }
    //print(state.signInStatus);
  }

  void onPerformSignInButtonPressed() {
    final username = usernameController.text;
    final password = passwordController.text;
    bloc.add(BlocEvent(LoginBlocEvents.performSignIn, data: {'email':username, 'password':password}));
  }

  void _showVerifyConnectionAlert(){
    _showSignInFailedAlert(
        'Verfique sua conexão com a internet!'
    );
  }

  void _showInvalidCredentialsAlert(){
    _showSignInFailedAlert(
        'Usuário ou senha inválida!'
    );
  }

  void _showNoPermissionAlert(){
    _showSignInFailedAlert(
        'Você não possui permissão de administrador!'
    );
  }

  void _showSignInFailedAlert(String message){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
            'Falha no Login'
        ),
        content: Text(
          message,
        ),
        actions: [
          FlatButton(
            child: Text(
                'OK'
            ),
            onPressed: ()=>Navigator.of(context).pop(),
          )
        ],
      );
    });
  }
}
