import 'package:flutter/material.dart';
import 'package:virtual_store/models/product.dart';

enum ProductTileStyle { list, grid }

class ProductTile extends StatelessWidget {
  ProductTile({
    Key key,
    ProductTileStyle style = ProductTileStyle.list,
    @required Product product,
  })  : assert(style != null),
        assert(product != null),
        _style = style,
        _product = product,
        super(key: key);

  final ProductTileStyle _style;
  final Product _product;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
