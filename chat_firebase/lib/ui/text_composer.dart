
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer({Key key, @required this.sendMessage}):super(key: key);

  final Function(String) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  ValueNotifier<bool> isComposing = ValueNotifier(false);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo_camera,
            ),
            onPressed: _onCameraButtonPressed,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                  hintText: 'Enviar uma Mensagem',
              ),
              onChanged: _onTextChanged,
              onSubmitted: _onTextSubmitted,
            ),
          ),
          _buildSendButtonWidget(),
        ],
      ),
    );
  }

  Widget _buildSendButtonWidget(){
    return ValueListenableBuilder(
      valueListenable: isComposing,
      builder: (_, bool value, Widget child){
        return IconButton(
          icon: Icon(
            Icons.send,
          ),
          onPressed: value ? _onSendButtonPressed : null,
        );
      },
    );
  }

  void _reset(){
    _controller.clear();
    isComposing.value = false;
  }

  void _onTextChanged(String text) {
    isComposing.value = text.isNotEmpty;
  }

  void _onTextSubmitted(String text) {
    _onSendButtonPressed();
  }

  void _onSendButtonPressed() {
    widget.sendMessage(_controller.text);
    _reset();
  }

  void _onCameraButtonPressed() {
    TextStyle style = Theme.of(context).textTheme.title;

    Scaffold.of(context).showBottomSheet((BuildContext context){
      return BottomSheet(
        onClosing: (){},
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  "Camera",
                  style: style,
                ),
                onPressed: (){
                  _choosePictureFrom(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              MaterialButton(
                child: Text(
                  "Galeria",
                  style: style,
                ),
                onPressed: () {
                  _choosePictureFrom(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              MaterialButton(
                child: Text(
                  "Cancelar",
                  style: style,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }


  void _choosePictureFrom(ImageSource source) async {
    File imageFile = await ImagePicker.pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800,
    );

  }
}
