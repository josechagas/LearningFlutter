
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/blocs/clients_bloc.dart';

class OrderTile extends StatelessWidget {
  OrderTile({@required this.order, @required this.clientsBlocState, Key key})
      : super(key: key);

  final DocumentSnapshot order;
  final ClientsBlocState clientsBlocState;

  String get orderCode =>
      order.id.substring(order.id.length - 7);
  int get status => order.data()['status'];
  String get stateString => states[status];
  String get productsPrice => order.data()['productsPrice'].toString();
  String get totalPrice => order.data()['totalPrice'].toString();
  Map<String, dynamic> get client =>
      clientsBlocState.users[order.data()['clientId']];
  String get clientName => client['name'];
  String get clientAddress => client['address'];

  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando entrega',
    'Entregue'
  ];

  @override
  Widget build(BuildContext context) {
    final defaultSpacer = const SizedBox(
      height: 20,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: status != 4,
          childrenPadding:
              EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 8),
          title: Text(
            '#$orderCode - $stateString',
            style: TextStyle(
              color: status != 4 /*entregue*/ ? Colors.grey[850] : Colors.green,
            ),
          ),
          children: [
            _buildLine(
              context,
              titleOne: clientName,
              titleTwo: 'Produtos: R\$$productsPrice',
            ),
            _buildLine(
              context,
              titleOne: clientAddress,
              titleTwo: 'Total: R\$$totalPrice',
            ),
            defaultSpacer,
            _buildOrderItemsList(context),
            defaultSpacer,
            Divider(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsList(BuildContext context) {
    final List products = order.data()['products'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: products.map((item) {
        final map = Map<String, dynamic>.from(item);
        return _buildOrderItem(context, map);
      }).toList(),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> data) {
    final title = data['product']['title'];
    final size = data['size'];
    final category = data['category'];
    final prodCode = data['pId'];
    final quant = data['quantity'];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '$title $size',
      ),
      subtitle: Text(
        '$category/$prodCode',
      ),
      trailing: Text('$quant'),
    );
  }

  Widget _buildLine(BuildContext context, {String titleOne, String titleTwo}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            titleOne,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            titleTwo,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            child: Text(
              'Excluir',
            ),
            textColor: Colors.redAccent,
            onPressed: () {},
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text('Regredir'),
            textColor: Colors.yellow,
            onPressed: status > 1 ? () => updateStatus(-1) : null,
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text('Avançar'),
            textColor: Colors.green,
            onPressed: status < 4 ? () => updateStatus(1) : null,
          ),
        ),
      ],
    );
  }

  void updateStatus(int by) {
    order.reference.updateData({
      'status': status + by,
    });
  }

  void deleteOrder() {
    Firestore.instance
        .collection('users')
        .doc(order.data()['clientId'])
        .collection('orders')
        .doc(order.id)
        .delete();
    order.reference.delete();
  }
}
