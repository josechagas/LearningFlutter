import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/cart_bloc.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/models/cart_product.dart';
import 'package:virtual_store/models/product.dart';
import 'package:virtual_store/router.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key, @required this.product}) : super(key: key);
  final Product product;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Product get product => widget.product;
  String _selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          style: Theme.of(context).textTheme.headline5,
          maxLines: 3,
        ),
        Text(
          priceText,
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        baseSpace,
        Text(
          'Descrição',
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          product.description,
        ),
        baseSpace,
        Text(
          'Tamanho',
          style: Theme.of(context).textTheme.headline6,
        ),
        _buildSizesWidget(),
        baseSpace,
        SizedBox(
          height: 50,
          child: Consumer<UserBloc>(
            builder: (context, bloc, child) {
              return RaisedButton(
                child: Text(
                  bloc.isLoggedIn ? 'Adicionar ao Carrinho' : 'Fazer Login',
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: bloc.isLoggedIn && (_selectedSize?.isEmpty ?? true) ? null : _onAddToCartButtonPressed,
              );
            },
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

  void showAddedToCartSnabBar(){
    final snackbarWidget = SnackBar(
        content: Text(
          'Item adicionado ao carrinho',
        ),
      action: SnackBarAction(
        label: 'Carrinho',
        onPressed: _goToCartPage,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbarWidget);
  }

  void _onAddToCartButtonPressed(){
    final userBloc = Provider.of<UserBloc>(context,listen: false);
    if(userBloc.isLoggedIn) {
      //add to cart
      final cartBloc = Provider.of<CartBloc>(context, listen: false);
      cartBloc.addCartItem(CartProduct(
        category: product.category,
        pId: product.id,
        size: _selectedSize,
        quantity: 1,
      ));
      showAddedToCartSnabBar();
    }
    else {
      Navigator.of(context).pushNamed(RootRouter.signIn);
    }
  }

  void _didSelectItemSize(String size) {
    setState(() {
      _selectedSize = _selectedSize == size ? null : size;
    });
  }

  void _goToCartPage(){
    Navigator.of(context,rootNavigator: true).pushNamed(RootRouter.cartPage);
  }
}
