import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final defaultSpacer = const SizedBox(
      height: 20,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          childrenPadding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 8),
          title: Text(
            '#12312312 - Entregue',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          children: [
            _buildLine(
              context,
              titleOne: 'Username',
              titleTwo: 'Produtos: ??',
            ),
            _buildLine(
              context,
              titleOne: 'address',
              titleTwo: 'Total: R\$ 99,99',
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOrderItem(context),
        _buildOrderItem(context),
        _buildOrderItem(context),
      ],
    );
  }

  Widget _buildOrderItem(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Nome do produto',
      ),
      subtitle: Text(
          'categoria/cod produto',
      ),
      trailing: Text(
        '2'
      ),
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

  Widget _buildActionButtons(BuildContext context){
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            child: Text(
              'Excluir',
            ),
            textColor: Colors.redAccent,
            onPressed: (){},
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text(
                'Regredir'
            ),
            textColor: Colors.yellow,
            onPressed: (){},
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text(
                'Avançar'
            ),
            textColor: Colors.green,
            onPressed: (){},
          ),
        ),
      ],
    );
  }
}
