import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/models/product.dart';
import 'package:virtual_store/ui/load_info_widget.dart';
import 'package:virtual_store/ui/product_tile.dart';

class CategoryDetailPage extends StatefulWidget {
  CategoryDetailPage({Key key, @required this.categorySnapshot})
      : super(key: key);

  final DocumentSnapshot categorySnapshot;

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  Future<QuerySnapshot> _categoryDetailFuture;

  @override
  void initState() {
    _initFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.categorySnapshot.data["title"],
          ),
          bottom: _buildTabBar(),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _categoryDetailFuture,
          builder: _buildFuture,
        ),
      ),
    );
  }

  Widget _buildFuture(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
      case ConnectionState.active:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        break;
    }

    if (snapshot.hasData && !snapshot.hasError) {
      return _buildBodyTabView(snapshot.data.documents);
    } else {
      return LoadInfoWidget(
        hasError: snapshot.hasError,
        onReloadPressed: _onReloadDataPressed,
      );
    }
  }

  Widget _buildBodyTabView(List<DocumentSnapshot> docs) {
    return TabBarView(
      //physics: NeverScrollableScrollPhysics(), // to disable scroll between pages.
      children: <Widget>[
        _buildProductsGridTab(docs),
        _buildProductsListTab(docs),
      ],
    );
  }

  Widget _buildProductsGridTab(List<DocumentSnapshot> docs) {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.65,
      ),
      itemCount: docs.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildProductTile(context, docs[index], ProductTileStyle.grid),
    );
  }

  Widget _buildProductsListTab(List<DocumentSnapshot> docs) {
    return ListView.builder(
      itemCount: docs.length,
      padding: EdgeInsets.all(5),
      itemBuilder: (BuildContext context, int index) =>
          _buildProductTile(context, docs[index], ProductTileStyle.list),
    );
  }

  Widget _buildProductTile(
      BuildContext context, DocumentSnapshot doc, ProductTileStyle style) {
    final product = Product.fromDocument(doc);
    product.category = widget.categorySnapshot.documentID;
    return ProductTile(
      style: style,
      product: product,
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      indicatorColor: Colors.white,
      tabs: <Widget>[
        Tab(
          icon: Icon(Icons.grid_on),
        ),
        Tab(
          icon: Icon(Icons.list),
        ),
      ],
    );
  }

  _initFuture() {
    _categoryDetailFuture = Firestore.instance
        .collection('products')
        .document(widget.categorySnapshot.documentID)
        .collection('items')
        .getDocuments();
  }

  _onReloadDataPressed() {
    setState(() {
      _initFuture();
    });
  }
}
