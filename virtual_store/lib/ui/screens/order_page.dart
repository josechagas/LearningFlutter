import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {

  OrderPage({Key key, this.orderId}):super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedido Realizado',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            Text(
              'Pedido realizado com sucesso!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SelectableText(
              'Código do pedido: $orderId',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
