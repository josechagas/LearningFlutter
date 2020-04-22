import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPageBloc {
  ValueNotifier isLoading = ValueNotifier<bool>(false);
  FirebaseAuth _auth = FirebaseAuth.instance;

  void dispose() {
    isLoading.dispose();
  }

  performSignUp(
      {@required String name,
      @required String address,
      @required String email,
      @required String password,
      VoidCallback onSuccess,
      Function(Object) onFailure}) async {
    isLoading.value = true;
    /*
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user);
      return Future.value(user != null);
    }
    catch (e){
      print(e);
    }
    return Future.value(false);
    */

    _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((user) async {

      await _saveUserData(
        name: name,
        address: address,
        email: email,
      );

      isLoading.value = false;
      onSuccess();

    }).catchError((e) {
      isLoading.value = false;
      onFailure(e);
    });
  }

  Future<void> _saveUserData({
    @required String name,
    @required String address,
    @required String email,
  }) async {
    final currentUser = await _auth.currentUser();
    if (currentUser?.uid != null) {
      await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .setData({'name': name, 'email': email, 'address': address});
    }

    return Future.value();
  }
}
