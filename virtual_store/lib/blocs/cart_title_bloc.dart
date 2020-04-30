import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/models/cart_product.dart';
import 'package:virtual_store/models/product.dart';

import 'cart_bloc.dart';

class CartTileBloc {

  CartTileBloc(this.cartProd);

  final CartProduct cartProd;
  Future<Product> _productInfoFuture;

  Future<Product> get productInfoFuture async {
    if(_productInfoFuture == null) {
      final snapshotDocument = await Firestore.instance.collection('products').document(cartProd.category)
          .collection('items').document(cartProd.pId).get();

      if(snapshotDocument != null)
        cartProd.productData = Product.fromDocument(snapshotDocument);

      _productInfoFuture = Future.value(cartProd.productData);
    }
    return _productInfoFuture;
  }


  void removeFromCart(BuildContext context) {
    final cartBloc = Provider.of<CartBloc>(context, listen:  false);
    cartBloc.removeCartItem(cartProd);
  }

  void decrementQuantity(BuildContext context) {
    final cartBloc = Provider.of<CartBloc>(context, listen:  false);
    cartBloc.decrementCartItem(this.cartProd);
  }

  void incrementQuantity(BuildContext context) {
    final cartBloc = Provider.of<CartBloc>(context, listen:  false);
    cartBloc.incrementCartItem(this.cartProd);
  }
}