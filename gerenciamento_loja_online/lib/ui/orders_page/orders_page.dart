import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/ui/orders_page/order_tile.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return OrderTile();
        },
      ),
    );
  }
}
