import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientTile extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildLine(
        context,
        titleOne: 'Title',
        titleTwo: 'Pedidos: 0',
      ),
      subtitle: _buildLine(
        context,
        titleOne: 'Subtitle',
        titleTwo: 'Gastos: 0',
      ),
    );
  }

  Widget _buildLine(BuildContext context, {@required String titleOne, @required titleTwo}) {
    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
      color: Colors.white,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
              titleOne,
            style: textStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            titleTwo+'99999',
            textAlign: TextAlign.right,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
