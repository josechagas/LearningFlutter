import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class LoginBloc extends Bloc<BlocEvent<LoginBlocEvents>, LoginBlocState> {
  LoginBloc(LoginBlocState initialState) : super(initialState) {
    _authStreamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if(await verifyIsAdmin(user)) {
          add(BlocEvent(LoginBlocEvents.updateSignInStatus, data: LoginStatus.successfull));
        }
        else {
          print('logout');
          await FirebaseAuth.instance.signOut();
          add(BlocEvent(LoginBlocEvents.updateSignInStatus, data: LoginStatus.noPermissions));
        }
      }
      else {
        add(BlocEvent(LoginBlocEvents.updateSignInStatus, data: LoginStatus.none));
      }
    });
  }

  StreamSubscription _authStreamSubscription;

  @override
  Stream<LoginBlocState> mapEventToState(
      BlocEvent<LoginBlocEvents> event) async* {
    var newState = LoginBlocState.fromState(state);
    switch (event.event) {
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
        yield newState;

        final loginState =
            await _performLogin(event.data['email'], event.data['password']);

        if(loginState != null) {
          newState = LoginBlocState.fromState(state);
          newState.signInStatus = loginState;
          yield newState;
        }
        break;
      case LoginBlocEvents.updateSignInStatus:
        newState = LoginBlocState.fromState(state);
        newState.signInStatus = event.data;
        yield newState;
        break;
      default:
        break;
    }
  }

  @override
  Future<void> close() {
    _authStreamSubscription.cancel();
    return super.close();
  }

  Future<LoginStatus> _performLogin(String email, String password) async {
    print('perform login');

    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((UserCredential value) {
          print('then');
          return value?.user != null
          ? null
          : LoginStatus.errorInvalidCredentials;
    })
        .catchError((error) {
      print('error');

      return LoginStatus.errorInvalidCredentials;
    });
  }

  Future<bool> verifyIsAdmin(FirebaseUser user) async {
    return await Firestore.instance
        .collection('admins')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((doc) {
      return doc?.documents != null && doc?.documents?.isNotEmpty ?? false;
    }).catchError((error) => false);
  }
}

enum LoginBlocEvents {
  performSignIn,
  credentialsInvalidFormat,
  credentialsValidFormat,
  updateSignInStatus
}

class LoginBlocState {
  LoginBlocState(
      {@required this.enableSignInButton,
      this.signInStatus = LoginStatus.none});

  factory LoginBlocState.fromState(LoginBlocState state) => LoginBlocState(
        enableSignInButton: state.enableSignInButton,
        signInStatus: state.signInStatus,
      );

  bool enableSignInButton;
  LoginStatus signInStatus;
}

enum LoginStatus {
  none,
  performing,
  successfull,
  errorInvalidCredentials,
  errorVerifyConnection,
  noPermissions
}
