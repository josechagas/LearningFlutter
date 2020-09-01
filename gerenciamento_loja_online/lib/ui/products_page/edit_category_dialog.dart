import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditCategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: GestureDetector(
              child: CircleAvatar(

              ),
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Categoria',
              ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              FlatButton(
                child: Text(
                  'Excluir',
                ),
                textColor: Colors.red,
                onPressed: (){},
              ),
              FlatButton(
                child: Text(
                  'Salvar',
                ),
                onPressed: (){},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
