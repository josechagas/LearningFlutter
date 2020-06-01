import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  OrderTile({Key key, @required this.orderId}):super(key:key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
        orderId,
      ),
    );
  }
}
