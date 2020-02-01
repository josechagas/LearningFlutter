import 'package:flutter/material.dart';
import 'package:gifs_app/models/item_model.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';


class GifPage extends StatelessWidget {

  GifPage({Key key,@required this.item}):super(key:key);

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final gifImage = item.images.fixed_height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: gifImage.url,
          ),
        ),
      )
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
          item.title
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: onShareButtonPressed,
        )
      ],
    );
  }

  void onShareButtonPressed(){
    final gifImage = item.images.fixed_height;
    Share.share(gifImage.url);
  }
}
