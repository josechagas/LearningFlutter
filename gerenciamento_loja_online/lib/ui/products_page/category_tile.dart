import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/router.dart';

class CategoryTile extends StatelessWidget {

  CategoryTile({@required this.category, Key key}):super(key: key);

  final DocumentSnapshot category;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Text(
          category.data['title'],
          style: TextStyle(
            color: Colors.grey[850],
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
            category.data['icon'],
          ),
        ),
        children: [
          _loadItemsOfCategory(),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Adicionar',
            ),
            onTap: (){
              goToProductPage(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _loadItemsOfCategory(){
    return FutureBuilder<QuerySnapshot>(
      future: category.reference.collection('items').getDocuments(),
      builder: (context, asyncSnapshot){
        if(asyncSnapshot.hasData) {
          return Column(
            children: _buildChildrenList(context, asyncSnapshot.data),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  List<Widget> _buildChildrenList(BuildContext context, QuerySnapshot data) {
    return data.documents.map<Widget>((item){
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
            item.data['images'][0],
          ),
        ),
        title: Text(
          item.data['title'],
        ),
        trailing: Text(
            'R\$${item.data['price']/100.0}'
        ),
        onTap: () => goToProductPage(context,product: item),
      );
    }).toList();
  }

  void goToProductPage(BuildContext context, {DocumentSnapshot product}) {
    final Map<String, dynamic> map =  {'categoryId':category.documentID};
    if(product != null){
      map['product'] = product;
    }
    Navigator.of(context).pushNamed(RootRouter.productPage,arguments:map);
  }
}
