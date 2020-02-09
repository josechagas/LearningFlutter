import 'package:chat_firebase/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Olá',
        ),
        elevation: 0,
      ),
      body: TextComposer(
        sendMessage: _sendMessage,
      ),
    );
  }

  void _sendMessage(String mess) {

    Firestore.instance.collection('messages').add(
      {
        "text": mess,
      }
    );

  }
}
