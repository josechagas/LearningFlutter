import 'dart:io';

import 'package:chat_firebase/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildMessagesWidget(),
          ),
          TextComposer(
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }


  Widget _buildMessagesWidget(){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('messages').snapshots(),
      builder: (context, snapshot){
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
          default:
            List<DocumentSnapshot> docs = snapshot.data?.documents?.reversed?.toList() ?? [];
            return ListView.builder(
              itemCount: docs.length,
                reverse: true,
                itemBuilder: (context, index){
                  final doc = docs[index];
                  return ListTile(
                    title: Text(
                        doc.data['text'] ?? '',
                    ),
                  );
                });
        }
      },
    );
  }

  void _sendMessage({String mess, File file}) async {

    Map<String, dynamic> map = {};

    if (file != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);

      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      map['imgUrl'] = url;
      print(url);
    }
    if(mess != null && mess.isNotEmpty) map['text'] = mess;
    Firestore.instance.collection('messages').add(map);

  }
}
