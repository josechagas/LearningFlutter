import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store/ui/load_info_widget.dart';


class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<QuerySnapshot> _firebaseFuture;

  @override
  void initState() {
    _initFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //*** É importante verificar se é possivel continuar em realtime e color o future
    //em uma variavel para evitar o reload sempre que o metodo 'build' é chamado.

    return Scaffold(
        body: Stack(
          children: <Widget>[
            _buildBodyBack(context),
            FutureBuilder<QuerySnapshot>(
              future: _firebaseFuture, //****
              builder: _buildBodyFuture,
            ),
          ],
        )
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
      return _buildStaggeredGrid(snapshot.data.documents);
    } else {
      return LoadInfoWidget(
        hasError: snapshot.hasError,
        onReloadPressed: _onReloadDataPressed,
      );
    }
  }

  Widget _buildStaggeredGrid(List<DocumentSnapshot> documents) {
    return StaggeredGridView.count(
        crossAxisCount: 2, //horizontal
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        staggeredTiles: documents.map((DocumentSnapshot doc) {
          return StaggeredTile.count(doc.data['x'], doc.data['y']);
        }).toList(),
        children: documents.map((DocumentSnapshot doc) {
          final imageUrl = doc.data['image'];
          if(imageUrl == null) {
            return Icon(
              Icons.image,
            );
          }
          return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageUrl,
            fit: BoxFit.cover,
          );
        }).toList());
  }

  Widget _buildBodyBack(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    );
  }

  _initFuture(){
    _firebaseFuture = Firestore.instance
        .collection('home')
        .orderBy('pos')
        .getDocuments();
  }

  _onReloadDataPressed(){
    setState(() {
      _initFuture();
    });
  }
}


class HomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Teste2',
        ),
      ),
    );
  }
}
