
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/models/cart_product.dart';
import 'package:virtual_store/router.dart';
import 'package:virtual_store/ui/cart_price_card.dart';
import 'package:virtual_store/ui/cart_tile.dart';
import 'package:virtual_store/ui/discount_card.dart';
import 'package:virtual_store/ui/load_info_widget.dart';
import 'package:virtual_store/ui/ship_card.dart';

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
      body: Consumer<CartBloc>(
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartBloc bloc, Widget child) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);

    if(!userBloc.isLoggedIn) {
      return _buildUserNotLoggedWidget(context);
    }
    else {
      return FutureBuilder<List<CartProduct>>(
        future: bloc.productsFuture,
        initialData: bloc.products,
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return ListView(
              children: <Widget>[
                Column(
                  children: bloc.products.map((item){
                    return CartTile(item, bloc);
                  }).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPriceCard(onFinishOrder: (){

                })
              ],
            );
          }
          else if(snapshot.connectionState == ConnectionState.active ||
          snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return LoadInfoWidget(
            hasError: snapshot.hasError,
          );
        },
      );
    }
  }

  Widget _buildUserNotLoggedWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.remove_shopping_cart,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Faça login e tenha acesso ao seu carrinho!',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text(
                'Entrar'
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () => _goToLoginPage(context),
          ),
        ],
      ),
    );
  }



  void _goToLoginPage(BuildContext context){
    Navigator.of(context, rootNavigator: true).pushNamed(RootRouter.signIn);
  }
}
