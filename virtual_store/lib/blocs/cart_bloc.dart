import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/models/cart_product.dart';

class CartBloc extends ChangeNotifier {
  CartBloc({this.currentUserId});
  bool isFinishingOrder = false;

  List<CartProduct> products = [];
  Future<List<CartProduct>> _productsFuture;

  String couponCode;
  int discountPercentage = 0;

  String currentUserId;

  bool get hasProducts => products != null && products.isNotEmpty;
  Future<List<CartProduct>> get productsFuture {
    if (_productsFuture == null) {
      _reloadCartItems();
    }
    return _productsFuture;
  }

  double shipPrice = 0.0;

  double get subtotal {
    double price = 0;
    if (hasProducts) {
      products?.forEach((element) {
        price += element.totalPrice;
      });
    }
    return price;
  }

  double get discountPrice {
    return subtotal * (discountPercentage / 100.0);
  }

  double get total {
    return subtotal - discountPrice + shipPrice;
  }

  void didUpdateUserBloc(UserBloc bloc) {
    if (bloc.user?.uid != currentUserId) {
      this.currentUserId = bloc.user?.uid;
      products.clear();
      _productsFuture = null;
      notifyListeners();
    }
  }

  void didLoadProductData() {
    notifyListeners();
  }

  void addCartItem(CartProduct item) {
    products.add(item);
    if (currentUserId != null) {
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .collection('cart')
          .add(item.toMap())
          .then((doc) {
        item.cId = doc.documentID;
      });
    }
    notifyListeners();
  }

  void removeCartItem(CartProduct item) {
    if (currentUserId != null) {
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .collection('cart')
          .document(item.cId)
          .delete();
    }
    products.removeWhere((prod) => prod.cId == item.cId);
    notifyListeners();
  }

  void decrementCartItem(CartProduct item) {
    item.quantity--;
    Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('cart')
        .document(item.cId)
        .updateData(item.toMap());

    notifyListeners();
  }

  void incrementCartItem(CartProduct item) {
    item.quantity++;
    Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('cart')
        .document(item.cId)
        .updateData(item.toMap());

    notifyListeners();
  }

  void setCoupon({@required String code, @required int discountPercentage}) {
    this.couponCode = code;
    this.discountPercentage = discountPercentage;
    notifyListeners();
  }

  void _reloadCartItems() {
    _productsFuture = _buildProductsFuture();
    _productsFuture.then((prods) {
      products = prods;
      notifyListeners();
    });
  }

  Future<List<CartProduct>> _buildProductsFuture() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('cart')
        .getDocuments();

    final products = snapshot.documents.map((doc) {
      return CartProduct.fromDocument(doc);
    }).toList();

    return products;
  }

  Future<String> finishOrder() async {
    if (hasProducts) {
      isFinishingOrder = true;
      notifyListeners();
      final subtotalPrice = subtotal;
      final discount = discountPrice;
      final shipPrice = this.shipPrice;

      DocumentReference refOrder =
          await Firestore.instance.collection('orders').add(
        {
          'clientId': currentUserId,
          'products': products.map((prod) => prod.toMap()).toList(),
          'shipPrice': shipPrice,
          'productsPrice': subtotalPrice,
          'discount': discount,
          'totalPrice': this.total,
          'status': 1,
        },
      );

      await Firestore.instance
          .collection('users')
          .document(this.currentUserId)
          .collection('orders')
          .document(refOrder.documentID)
          .setData(
        {
          'orderId': refOrder.documentID,
        },
      );

      QuerySnapshot query = await Firestore.instance.collection('users').document(this.currentUserId).collection('cart').getDocuments();
      query.documents.forEach((doc) {
        doc.reference.delete();
      });

      products.clear();
      couponCode = null;
      discountPercentage = 0;
      isFinishingOrder = false;
      notifyListeners();
      return refOrder.documentID;
    }
    return null;
  }

  String formattedTotalPrice() {
    return NumberFormat.simpleCurrency(locale: "pt_BR").format(total);
  }

  String formattedSubtotal() {
    return NumberFormat.simpleCurrency(locale: "pt_BR").format(subtotal);
  }

  String formattedDiscount() {
    return NumberFormat.simpleCurrency(locale: "pt_BR").format(discountPrice);
  }

  String formattedShipPrice() {
    return NumberFormat.simpleCurrency(locale: "pt_BR").format(shipPrice);
  }
}
