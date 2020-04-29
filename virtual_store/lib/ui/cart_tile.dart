import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';
import 'package:virtual_store/blocs/cart_title_bloc.dart';
import 'package:virtual_store/models/cart_product.dart';
import 'package:virtual_store/models/product.dart';
import 'package:virtual_store/ui/load_info_widget.dart';

class CartTile extends StatelessWidget {
  CartTile(CartProduct cartProd, {Key key})
      : bloc = CartTileBloc(cartProd),
        super(key: key);

  final CartTileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: FutureBuilder<Product>(
        future: bloc.productInfoFuture,
        initialData: bloc.cartProd.productData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 70.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _buildContent();
          } else {
            return LoadInfoWidget(
              hasError: snapshot.hasError,
            );
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    return Container();
  }

}
