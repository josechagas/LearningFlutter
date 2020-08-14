import 'package:flutter/material.dart';

class ListData extends StatelessWidget {
  ListData({this.title, this.subtitle, this.image, this.bottomMargin, Key key})
      : super(key: key);

  final String title;
  final String subtitle;
  final ImageProvider image;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: bottomMargin),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
