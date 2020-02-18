import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.isMine, {Key key}) : super(key: key);

  final Map<String, dynamic> data;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final imgUrl = data['imgUrl'] as String;
    final hasImg = imgUrl != null && imgUrl.isNotEmpty;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          !isMine ? _buildAvatarWidget() : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                hasImg
                    ? Image.network(
                        imgUrl,
                        width: 200,
                      )
                    : Text(
                        data['text'] ?? '',
                        style: Theme.of(context).textTheme.subhead,
                        textAlign: isMine ? TextAlign.end : TextAlign.start,
                      ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data['senderName'] ?? '',
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          isMine ? _buildAvatarWidget() : Container(),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget() {
    final widgets = [
      SizedBox(
        width: 20,
      ),
      CircleAvatar(
        backgroundImage: NetworkImage(
          data['senderPhotoUrl'],
        ),
      ),
    ];

    return Row(
      children: isMine ? widgets : widgets.reversed.toList(),
    );
  }
}
