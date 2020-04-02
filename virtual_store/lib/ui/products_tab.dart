import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store/router.dart';
import 'package:virtual_store/ui/load_info_widget.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  Future<QuerySnapshot> _firebaseFuture;

  @override
  void initState() {
    _initFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: _firebaseFuture, //****
        builder: _buildBodyFuture,
      ),
    );
  }

  Widget _buildBodyFuture(
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
      return _buildCategoriesListView(snapshot.data.documents);
    } else {
      return LoadInfoWidget(
        hasError: snapshot.hasError,
        onReloadPressed: _onReloadDataPressed(),
      );
    }
  }

  Widget _buildCategoriesListView(List<DocumentSnapshot> documents) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final doc = documents[index];
          return _buildCategoryListTile(doc);
        },
        separatorBuilder: (_, __) {
          return Divider();
        },
        itemCount: documents.length);
  }

  Widget _buildCategoryListTile(DocumentSnapshot doc) {
    final data = doc.data;
    final icon = data['icon'];
    return ListTile(
      leading: icon != null
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: icon,
              fit: BoxFit.cover,
              height: 40,
              width: 40,
            )
          : Icon(
              Icons.image,
            ),
      title: Text(
        data['title'] ?? 'no title',
      ),
      trailing: Icon(
        Icons.chevron_right,
      ),
      onTap: () => _onCategoryListTileTap(doc),
    );
  }

  _initFuture() {
    _firebaseFuture = Firestore.instance.collection('products').getDocuments();
  }

  _onReloadDataPressed() {
    setState(() {
      _initFuture();
    });
  }

  _onCategoryListTileTap(DocumentSnapshot doc) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      RootRouter.categoryDetail,
      arguments: doc,
    );
  }
}
