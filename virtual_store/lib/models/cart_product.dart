import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:virtual_store/models/product.dart';

class CartProduct {
  String cId;
  String category;
  String pId;
  int quantity;
  String size;

  Product productData;

  CartProduct({
    @required this.size,
    @required this.pId,
    @required this.category,
    this.quantity = 1,
  });

  CartProduct.fromDocument(DocumentSnapshot doc) {
    cId = doc.documentID;
    category = doc.data['category'];
    pId = doc.data['pId'];
    quantity = doc.data['quantity'];
    size = doc.data['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pId': pId,
      'quantity': quantity,
      'size': size,
      //'product': productData.toResumedMap(),
    };
  }
}
