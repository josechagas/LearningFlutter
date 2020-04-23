import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPageBloc {
  ValueNotifier isLoading = ValueNotifier<bool>(false);

  void dispose() {
    isLoading.dispose();
  }

  void performSignIn(
      {@required String email,
      @required String password,
      VoidCallback onSuccess,
      Function(Object) onFailure}) async {
    isLoading.value = true;

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((FirebaseUser user) {
      isLoading.value = false;
      onSuccess();
    }).catchError((e) {
      print(e);
      isLoading.value = false;
      onFailure(e);
    });
  }
}
