import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store/ui/load_info_widget.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //*** É importante verificar se é possivel continuar em realtime e color o future
    //em uma variavel para evitar o reload sempre que o metodo 'build' é chamado.

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBodyBack(context),
          FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection('home')
                .orderBy('pos')
                .getDocuments(), //****
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
          return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: doc.data['image'],
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
