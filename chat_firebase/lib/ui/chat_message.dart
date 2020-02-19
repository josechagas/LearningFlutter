import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.isMine, {Key key}) : super(key: key);

  final Map<String, dynamic> data;
  final bool isMine;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Visibility(
            child: _buildAvatarWidget(),
            visible: !isMine,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                _buildBallonWidget(context),
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
          Visibility(
            child: _buildAvatarWidget(),
            visible: isMine,
          ),
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

  Widget _buildBallonWidget(BuildContext context) {
    final imgUrl = data['imgUrl'] as String;
    final hasImg = imgUrl != null && imgUrl.isNotEmpty;

    final padding = hasImg
        ? EdgeInsets.symmetric(vertical: 5, horizontal: 5)
        : EdgeInsets.symmetric(vertical: 10, horizontal: 20);

    final content = hasImg
        ? ClipRRect(
            child: Image.network(
              imgUrl,
              width: 200,
            ),
            borderRadius: BorderRadius.circular(10),
          )
        : Text(
            data['text'] ?? '',
            style: Theme.of(context).textTheme.subhead.copyWith(
                  color: Colors.white,
                ),
            textAlign: isMine ? TextAlign.end : TextAlign.start,
          );

    return Material(
        color: isMine ? Colors.blue : Colors.green,
      child: Padding(
        padding: padding,
        child: content,
      ),
      borderRadius: BorderRadiusDirectional.circular(hasImg ? 10 : 25),
    );
  }
}
