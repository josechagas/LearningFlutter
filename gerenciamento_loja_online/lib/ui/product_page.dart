import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductPage extends StatelessWidget {

  ProductPage({@required this.categoryId, this.product, Key key}):super(key:key);

  final String categoryId;
  final DocumentSnapshot product;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
