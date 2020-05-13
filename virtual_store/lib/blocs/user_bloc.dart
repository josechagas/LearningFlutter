import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserBloc extends ChangeNotifier {
  FirebaseUser user;
  Map<String,dynamic> userData;
  bool get isLoggedIn => user != null && userData != null && userData.isNotEmpty;

  UserBloc():super(){
    loadUser();
  }

  String get userName {
    if(isLoggedIn){
      return userData['name'];
    }
    return null;
  }

  Future<void> loadUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      final snapshot = await Firestore.instance
          .collection('users')
          .document(user.uid).get();
      userData = snapshot.data;
    }
    notifyListeners();
    return Future.value();
  }

  Future<void> signOut() async {
    user = null;
    userData = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    return Future.value();
  }

}