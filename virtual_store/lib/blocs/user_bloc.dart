import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserBloc extends ChangeNotifier {
  FirebaseUser user;
  bool get isLoggedIn => user != null;

  UserBloc():super(){
    loadUser();
  }

  Future<void> loadUser() async {
    user = await FirebaseAuth.instance.currentUser();
    notifyListeners();
    return Future.value();
  }

  Future<void> signOut() async {
    user = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    return Future.value();
  }

}