import 'dart:io';

import 'package:chat_firebase/ui/chat_message.dart';
import 'package:chat_firebase/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> _scafKey = GlobalKey();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafKey,
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
            sendMessage: _onSendMessageAction,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            List<DocumentSnapshot> docs =
                snapshot.data?.documents?.reversed?.toList() ?? [];
            return ListView.builder(
                itemCount: docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return ChatMessage(doc.data, true);
                });
        }
      },
    );
  }

  void _showLoginErrorSnackbar(){
    _scafKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              'Não foi possível fazer o login, tente novamente.'
          ),
        )
    );
  }

  void _onSendMessageAction({String mess, File file}) async {
    final FirebaseUser user = await _getUser();

    if(user == null) {
      _showLoginErrorSnackbar();
    }
    else {
      await _sendMessage(user,mess: mess, file: file);
    }
  }

  void _sendMessage(FirebaseUser user, {String mess, File file}) async {
    Map<String, dynamic> map = {
      'uId': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoUrl,
    };

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
    if (mess != null && mess.isNotEmpty) map['text'] = mess;
    Firestore.instance.collection('messages').add(map);
  }

  /**
   * Gets current user or perfomr sign in to get the one.
   *
   * */
  Future<FirebaseUser> _getUser() async {
    if(_currentUser != null) {
      return _currentUser;
    }
    else {
      try {
        final GoogleSignInAccount account = await googleSignIn.signIn();
        final GoogleSignInAuthentication auth = await account.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: auth.idToken, accessToken: auth.accessToken);

        final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

        final FirebaseUser user = authResult.user;
        return user;
      } catch (error) {
        print(error.toString());
      }
      return null;
    }
  }
}
