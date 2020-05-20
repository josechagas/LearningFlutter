import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/models/cart_product.dart';
import 'package:virtual_store/models/product.dart';

import 'cart_bloc.dart';

class CartTileBloc {

  CartTileBloc({@required this.cartProd, @required this.cartBloc});

  final CartProduct cartProd;
  final CartBloc cartBloc;

  Future<Product> _productInfoFuture;

  Future<Product> get productInfoFuture async {
    if(_productInfoFuture == null) {
      final snapshotDocument = await Firestore.instance.collection('products').document(cartProd.category)
          .collection('items').document(cartProd.pId).get();

      if(snapshotDocument != null){
        cartProd.productData = Product.fromDocument(snapshotDocument);
        cartBloc.didLoadProductData();
      }

      _productInfoFuture = Future.value(cartProd.productData);
    }
    return _productInfoFuture;
  }


  void removeFromCart() {
    cartBloc.removeCartItem(cartProd);
  }

  void decrementQuantity() {
    cartBloc.decrementCartItem(this.cartProd);
  }

  void incrementQuantity() {
    cartBloc.incrementCartItem(this.cartProd);
  }
}