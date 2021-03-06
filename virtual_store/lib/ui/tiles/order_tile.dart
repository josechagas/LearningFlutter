import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_store/models/cart_product.dart';
import 'package:virtual_store/ui/widgets/load_info_widget.dart';

class OrderTile extends StatelessWidget {
  OrderTile({Key key, @required this.orderId}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('orders')
              .document(orderId)
              .snapshots(),
          builder: _streamBuilder,
        ),
      ),
    );
  }

  Widget _streamBuilder(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.hasData) {
      return _buildBody(snapshot.data);
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(DocumentSnapshot data) {
    final int status = data.data["status"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Código do pedido: ${data.documentID}',
          maxLines: 5,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          _buildProductsText(data),
        ),
        Text(
          _buildTotalPriceText(data),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            'Status do Pedido:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildStepsWidget(status),
      ],
    );
  }

  Widget _buildStepsWidget(int status) {
    final divider = Expanded(
      child: Divider(
        color: Colors.black54,
      ),
    );

    return Row(
      children: <Widget>[
        _buildCircle("1", "Preparação", status, 1),
        divider,
        _buildCircle("2", "Transporte", status, 2),
        divider,
        _buildCircle("3", "Entrega", status, 3),
      ],
    );
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;
    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      );
    } else if (status == thisStatus) {
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          child: child,
          backgroundColor: backColor,
        ),
        Text(
          subtitle,
        ),
      ],
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String message = 'Descrição:';
    for (LinkedHashMap p in snapshot.data['products']) {
      final quantity = p['quantity'];
      final title = p['product']['title'];
      final int priceCents = p['product']['price'];
      final price = priceCents / 100.0;
      final priceString = formattedPrice(price);
      message += '\n$quantity x $title ($priceString)';
    }
    //final double totalPrice = snapshot.data['totalPrice'];
    //message += 'Total: ${formattedPrice(totalPrice)}';
    return message;
  }

  String _buildTotalPriceText(DocumentSnapshot snapshot) {
    final double totalPrice = snapshot.data['totalPrice'];
    return 'Total: ${formattedPrice(totalPrice)}';
  }

  String formattedPrice(double value) {
    return NumberFormat.simpleCurrency(locale: "pt_BR").format(value);
  }
}
