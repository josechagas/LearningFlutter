import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';
import 'package:virtual_store/ui/widgets/load_action_button.dart';

class CartPriceCard extends StatelessWidget {
  CartPriceCard({Key key, @required this.onFinishOrder}) : super(key: key);

  final VoidCallback onFinishOrder;

  @override
  Widget build(BuildContext context) {
    final CartBloc bloc = Provider.of<CartBloc>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildRow(
              title: 'Subtotal',
              price: bloc.formattedSubtotal(),
            ),
            Divider(),
            _buildRow(
              title: 'Desconto',
              price: bloc.formattedDiscount(),
            ),
            Divider(),
            _buildRow(
              title: 'Entrega',
              price: bloc.formattedShipPrice(),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bloc.formattedTotalPrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: LoadActionButton(
                isLoading: bloc.isFinishingOrder,
                child: Text(
                  'Finalizar Pedido',
                ),
                onPressed: onFinishOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({@required String title, @required String price}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
        ),
        Text(
          price,
        ),
      ],
    );
  }
}
