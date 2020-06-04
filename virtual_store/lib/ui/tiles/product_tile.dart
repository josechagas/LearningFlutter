import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store/models/product.dart';
import 'package:virtual_store/router.dart';

enum ProductTileStyle { list, grid }

class ProductTile extends StatelessWidget {
  ProductTile({
    Key key,
    ProductTileStyle style = ProductTileStyle.list,
    @required Product product,
  })  : assert(style != null),
        assert(product != null),
        _style = style,
        _product = product,
        super(key: key);

  final ProductTileStyle _style;
  final Product _product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: _style == ProductTileStyle.grid
            ? _buildContentGridStyle(context)
            : _buildContentListStyle(context),
      ),
      onTap: ()=> _onCardTap(context),
    );
  }

  Widget _buildContentGridStyle(BuildContext context) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: _buildImageChild(),
        ),
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: _buildContentChild(context),
        )
      ],
    );

    return Padding(
      padding: EdgeInsets.all(8),
      child: column,
    );
  }

  Widget _buildContentListStyle(BuildContext context) {
    final row = Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: _buildImageChild(),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            child: _buildContentChild(context),
            padding: EdgeInsets.only(left: 8),
          ),
        )
      ],
    );
    return Padding(
      padding: EdgeInsets.all(8),
      child: row,
    );
  }

  Widget _buildImageChild(){
    String image;
    if (_product.images.isNotEmpty) image = _product.images.first as String;
    return image != null && image.isNotEmpty
        ? FadeInImage.memoryNetwork(
      placeholder: kTransparentImage, image: image,fit: BoxFit.cover)
        : Icon(
      Icons.broken_image,
    );
  }

  Widget _buildContentChild(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _product.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          _formattedPrice(),
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor
          ),
        )
      ],
    );
  }

  void _onCardTap(BuildContext context) {
    Navigator.of(context).pushNamed(RootRouter.productDetail,arguments: _product);
  }

  String _formattedPrice(){
    return NumberFormat.simpleCurrency(locale: "pt_BR").format(_product.price);
  }
}
