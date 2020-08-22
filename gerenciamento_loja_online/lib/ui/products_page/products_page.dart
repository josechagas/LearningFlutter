import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/ui/products_page/category_tile.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with AutomaticKeepAliveClientMixin<ProductsPage> {



  Future<QuerySnapshot> categoriesFuture = Firestore.instance.collection('products').getDocuments();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuerySnapshot>(
      future: categoriesFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            );
          default:
            break;
        }

        if(snapshot.hasError) {
          return Center(
            child: Text(
              'Ocorreu um erro em carregar as Categorias!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }
        return _buildCategoriesList(context, snapshot.data);
      },
    );
  }

  Widget _buildCategoriesList(BuildContext context, QuerySnapshot data){
    return ListView.builder(
      itemCount: data?.documents?.length ?? 0,
        itemBuilder: (context, index) => _buildCategoryItem(context, data.documents[index]));
  }

  Widget _buildCategoryItem(BuildContext context, DocumentSnapshot item){
    return CategoryTile(category: item,);
  }

  @override
  bool get wantKeepAlive => true;
}
