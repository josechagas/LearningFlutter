import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Adicione o novo Tamanho'
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Tamanho',
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            'Cancelar'
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            'Adicionar',
          ),
          onPressed: () => Navigator.of(context).pop(_controller.text),
        ),
      ],
    );
  }
}
