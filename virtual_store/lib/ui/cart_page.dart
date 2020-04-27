import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meu Carrinho',
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: Consumer<CartBloc>(
              builder: (context, bloc, child){
                final int count = bloc.products.length ?? 0;
                return Text(
                  '$count ${count == 1 ? 'ITEM' : 'ITENS'}',
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
