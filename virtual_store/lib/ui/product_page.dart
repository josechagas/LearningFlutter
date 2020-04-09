import 'package:flutter/material.dart';
import 'package:virtual_store/models/product.dart';

class ProductPage extends StatefulWidget {

  ProductPage({Key key, @required this.product}):super(key:key);
  final Product product;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  Product get product => widget.product;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
