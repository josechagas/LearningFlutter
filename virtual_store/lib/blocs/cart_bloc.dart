import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/models/cart_product.dart';

class CartBloc extends ChangeNotifier {
  CartBloc({this.currentUserId});

  List<CartProduct> products = [];
  String currentUserId;
  bool isLoading = false;

  bool get hasProducts => products != null && products.isNotEmpty;

  void didUpdateUserBloc(UserBloc bloc){
    if(bloc.user?.uid != currentUserId) {
      this.currentUserId = bloc.user?.uid;
      products.clear();
      notifyListeners();
    }
  }

  void addCartItem(CartProduct item) {
    products.add(item);
    if(currentUserId != null) {
      Firestore.instance.collection('users').document(currentUserId)
          .collection('cart').add(item.toMap())
          .then((doc){
            item.cId = doc.documentID;
      });
    }
    notifyListeners();
  }

  void removeCartItem(CartProduct item) {
    if(currentUserId != null) {
      Firestore.instance.collection('users').document(currentUserId)
          .collection('cart').document(item.cId).delete();
    }
    products.removeWhere((prod)=> prod.cId == item.cId);
    notifyListeners();
  }
}