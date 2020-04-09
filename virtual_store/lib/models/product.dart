import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String title;
  String description;
  int priceCents;
  List<dynamic> images;
  List<dynamic> sizes;
  String category;

  double get price => priceCents/100.0;

  Product.fromDocument(DocumentSnapshot snapshot):
        id = snapshot.documentID,
        title = snapshot.data["title"],
        description = snapshot.data["description"],
        priceCents = snapshot.data["price"],
        images = snapshot.data["images"],
        sizes = snapshot.data["sizes"];
}