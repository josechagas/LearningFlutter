import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CartBloc>(context, listen: false);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: Icon(
          Icons.card_giftcard,
        ),
        trailing: Icon(
          Icons.add,
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              initialValue: bloc.couponCode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom',
              ),
              onFieldSubmitted: (value) => _onFieldSubmitted(value, context),
            ),
          )
        ],
      ),
    );
  }

  void _onFieldSubmitted(String value, BuildContext context) {
    Firestore.instance.collection('coupons').document(value).get().then((doc){
      String message;
      if(doc.data != null) {
        //valid coupon
        final discount = doc.data['percent'];
        final bloc = Provider.of<CartBloc>(context, listen: false);
        bloc.setCoupon(code: value, discountPercentage: discount);
        message = 'Desconto de ${discount}% aplicado!';
      }
      else {
        message = 'Cupom não existente!';
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              message
          ),
        )
      );

    });
  }

}
