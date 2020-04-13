import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store/models/product.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key, @required this.product}) : super(key: key);
  final Product product;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Product get product => widget.product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        _buildImagesWidget(),
        Padding(
          padding: EdgeInsets.all(15),
          child: _buildItemInfoWidget(),
        )
      ],
    );
  }

  Widget _buildImagesWidget() {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Carousel(
        images: product.images?.map((item) {
          //Not compatible with FadeInImage widget
          return Image.network(
            item as String,
            fit: BoxFit.cover,
          );
        })?.toList(),
        dotSize: 4.0,
        dotSpacing: 15.0,
        //dotBgColor: Colors.black26,
        //dotColor: Theme.of(context).primaryColor,
        //dotIncreasedColor: Theme.of(context).primaryColor,
        //autoplayDuration: Duration(seconds: 15),
        autoplay: false,
      ),
    );
  }

  Widget _buildItemInfoWidget(){
    final priceText = NumberFormat.simpleCurrency(locale: "pt_BR").format(product.price);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          product.title,
          style: Theme.of(context).textTheme.title,
          maxLines: 3,
        ),
        Text(
            priceText,
          style: Theme.of(context).textTheme.title.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
