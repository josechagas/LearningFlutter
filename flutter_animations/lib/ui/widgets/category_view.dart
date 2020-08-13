
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

  final List<String> _categories = [
    'Trabalho',
    'Estudos',
    'Casa',
  ];

  int categoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.chevron_left,
          ),
          color: Colors.white,
          disabledColor: Colors.white54,
          onPressed: categoryIndex == 0 ? null : ()=>_updateCategory(-1),
        ),
        Text(
          _categories[categoryIndex].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
        IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.chevron_right,
          ),
          color: Colors.white,
          disabledColor: Colors.white54,
          onPressed: categoryIndex == _categories.length -1 ? null : ()=>_updateCategory(1),
        ),
      ],
    );
  }


  void _updateCategory(int byCount) {
    final newIndex = categoryIndex + byCount;
    setState(() {
      categoryIndex = newIndex;
    });
  }
}
