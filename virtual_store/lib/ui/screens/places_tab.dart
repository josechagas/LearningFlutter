import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/ui/tiles/place_tile.dart';
import 'package:virtual_store/ui/widgets/load_info_widget.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('places').getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _buildPlacesList(snapshot.data);
          }
          return LoadInfoWidget(
            hasError: snapshot.hasError,
          );
        },
      ),
    );
  }

  Widget _buildPlacesList(QuerySnapshot data) {
    return ListView(
      children: data.documents
          .map(
            (place) => PlaceTile(
              place: place,
            ),
          )
          .toList(),
    );
  }
}
