import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
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
      child: Padding(
        padding: EdgeInsets.all(8),
        child: bloc.cartProd.productData != null
            ? _buildContent(context)
            : FutureBuilder<Product>(
                future: bloc.productInfoFuture,
                initialData: bloc.cartProd.productData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildContent(context);
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 70.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return LoadInfoWidget(
                      hasError: snapshot.hasError,
                    );
                  }
                },
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FadeInImage.memoryNetwork(
          width: 120,
          height: 120,
          placeholder: kTransparentImage,
          fit: BoxFit.contain,
          image: bloc.cartProd.productData.images[0],
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                bloc.cartProd.productData.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              Text(
                'Tamanho: ${bloc.cartProd.size}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                NumberFormat.simpleCurrency(locale: "pt_BR")
                    .format(bloc.cartProd.productData.price),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: bloc.cartProd.quantity <= 1
                        ? null
                        : () => bloc.decrementQuantity(context),
                  ),
                  Text(
                    bloc.cartProd.quantity.toString(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => bloc.incrementQuantity(context),
                  ),
                  MaterialButton(
                    child: Text(
                      'Remover',
                    ),
                    textColor: Colors.grey[400],
                    onPressed: () => bloc.removeFromCart(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
