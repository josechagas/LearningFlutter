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

  String _selectedSize;

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

  Widget _buildItemInfoWidget() {
    final baseSpace = SizedBox(
      height: 16,
    );
    final priceText =
        NumberFormat.simpleCurrency(locale: "pt_BR").format(product.price);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          product.title,
          style: Theme.of(context).textTheme.headline,
          maxLines: 3,
        ),
        Text(
          priceText,
          style: Theme.of(context).textTheme.title.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        baseSpace,
        Text(
          'Descrição',
          style: Theme.of(context).textTheme.title,
        ),
        Text(
          product.description,
        ),
        baseSpace,
        Text(
          'Tamanho',
          style: Theme.of(context).textTheme.title,
        ),
        _buildSizesWidget(),
        baseSpace,
        SizedBox(
          height: 50,
          child: RaisedButton(
            child: Text(
              'Adicionar ao Carrinho',
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: _selectedSize?.isEmpty ?? true ? null : _onAddToCartButtonPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildSizesWidget() {
    Color colorFor(String size) =>
        _selectedSize == size ? Theme.of(context).primaryColor : Colors.grey;
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 10,
      //runSpacing: 5,
      children: product.sizes.map((item) {
        final itemSize = item as String;
        final color = colorFor(itemSize);
        /*return InkWell(
          onTap: () => _didSelectItemSize(itemSize),
          child: Container(
            width: 70,
            height: 34,
            alignment: Alignment.center,
            child: Text(
              itemSize as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: color,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );*/

        return MaterialButton(
          child: Text(
            itemSize,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          textColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: color, width: 2),
          ),
          onPressed: () => _didSelectItemSize(itemSize),
        );
      }).toList(),
    );
  }

  void _onAddToCartButtonPressed(){

  }

  void _didSelectItemSize(String size) {
    setState(() {
      _selectedSize = _selectedSize == size ? null : size;
    });
  }
}
