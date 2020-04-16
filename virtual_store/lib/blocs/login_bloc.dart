import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginBloc {
  ValueNotifier isLoading = ValueNotifier<bool>(false);

  void dispose(){
    isLoading.dispose();
  }

  Future<void> performSignIn() async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 3));
    isLoading.value = false;

    return Future.value();
  }
}