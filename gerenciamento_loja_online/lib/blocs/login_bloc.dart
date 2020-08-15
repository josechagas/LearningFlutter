import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class LoginBloc extends Bloc<BlocEvent<LoginBlocEvents>,LoginBlocState> {
  LoginBloc(LoginBlocState initialState) : super(initialState);

  @override
  Stream<LoginBlocState> mapEventToState(BlocEvent<LoginBlocEvents> event) async* {
    var newState =  LoginBlocState.fromState(state);
    switch(event.event) {
      case LoginBlocEvents.credentialsInvalidFormat:
        newState.enableSignInButton = false;
        yield newState;
        break;
      case LoginBlocEvents.credentialsValidFormat:
        newState.enableSignInButton = true;
        yield newState;
        break;
      case LoginBlocEvents.performSignIn:
        newState.signInStatus = LoginStatus.performing;
        print(event.data);
        yield newState;
        await Future.delayed(Duration(seconds: 10));
        newState =  LoginBlocState.fromState(state);
        newState.signInStatus = LoginStatus.errorVerifyConnection;
        yield newState;
        break;
      default:
        break;
    }
  }
}

enum LoginBlocEvents {
  performSignIn,
  credentialsInvalidFormat,
  credentialsValidFormat
}

class LoginBlocState {
  LoginBlocState({@required this.enableSignInButton,this.signInStatus = LoginStatus.none});
  
  factory LoginBlocState.fromState(LoginBlocState state)=> LoginBlocState(
    enableSignInButton: state.enableSignInButton,
    signInStatus:  state.signInStatus,
  );
  
  bool enableSignInButton;
  LoginStatus signInStatus;
}

enum LoginStatus {
  none,
  performing,
  errorInvalidCredentials,
  errorVerifyConnection
}