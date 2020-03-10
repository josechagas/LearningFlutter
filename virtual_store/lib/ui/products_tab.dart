import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/ui/load_info_widget.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection('home')
            .orderBy('pos')
            .getDocuments(), //****
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
      return Container();
    } else {
      return LoadInfoWidget(
        hasError: snapshot.hasError,
      );
    }
  }
}
