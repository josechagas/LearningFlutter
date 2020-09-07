import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ProductBloc extends Bloc<BlocEvent<ProductBlocEvent>, ProductBlocState> {
  ProductBloc(ProductBlocState initialState) : super(initialState);

  @override
  Stream<ProductBlocState> mapEventToState(
      BlocEvent<ProductBlocEvent> event) async* {
    switch (event.event) {
      case ProductBlocEvent.save:
        final newState = ProductBlocState.fromState(state);
        newState.updateStatus = ProductUpdateStatus.saving;
        yield newState;
        yield await _saveChanges(event.data);
        break;
      case ProductBlocEvent.delete:
        if (state.mode == ProductPageMode.editProd) {
          final newState = ProductBlocState.fromState(state);
          newState.updateStatus = ProductUpdateStatus.deleting;
          yield newState;
          yield await _deleteProduct();
        }
        break;
      default:
        break;
    }
  }

  Future<ProductBlocState> _deleteProduct() async {
    await state.product.reference.delete();
    final newState2 = ProductBlocState.fromState(state);
    newState2.updateStatus = ProductUpdateStatus.successDeleting;
    return newState2;
  }

  Future<ProductBlocState> _saveChanges(Map<String, dynamic> data) async {
    double price = data['price'];
    data['price'] = (price*100).round();
    final newState = ProductBlocState.fromState(state);
    try {
      if (state.mode == ProductPageMode.editProd) {
        final imagesUrls = await _uploadImages(data['images'],
            newState.product.documentID); //need reference to product.
        data['images'] =
            imagesUrls; //update the value to keep only the urls of uploaded images, removing references to local files.
        await newState.product.reference.update(data);
      } else {
        final List images = data['images'];
        DocumentReference newProdReference = await FirebaseFirestore.instance
            .collection('products')
            .doc(state.categoryId)
            .collection('items')
            .add(data..remove('images'));
        final imagesUrls =
            await _uploadImages(images, newProdReference.documentID);
        await newProdReference.updateData({'images': imagesUrls});
        newState.product = await newProdReference.get();
      }
      newState.updateStatus = ProductUpdateStatus.successSaving;
    } catch (e) {
      print(e);
      newState.updateStatus = ProductUpdateStatus.failedSaving;
    }
    return newState;
  }

  Future<List<String>> _uploadImages(List images, String productId) async {
    final String categoryId = state.categoryId;
    final List<String> imagesUrls = [];
    for (int index = 0; index < images.length; index++) {
      final image = images[index];
      if (image is File) {
        StorageTaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child(categoryId)
            .child(productId)
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(image)
            .onComplete;

        String downloadUrl = await snapshot.ref.getDownloadURL();
        imagesUrls.add(downloadUrl);
      } else {
        imagesUrls.add(image);
      }
    }
    return imagesUrls;
  }
}

enum ProductBlocEvent { save, delete }

class ProductBlocState {
  ProductBlocState({this.categoryId, this.product}) {
    sizesList = List.from(prodMap['sizes'] ?? []);
    imagesList = List.from(prodMap['images'] ?? []);
  }

  factory ProductBlocState.fromState(ProductBlocState state) =>
      ProductBlocState(
        product: state.product,
        categoryId: state.categoryId,
      );

  String categoryId;

  DocumentSnapshot product;
  Map<String, dynamic> get prodMap =>
      product != null ? Map.of(product.data()) : {};

  List<String> imagesList;
  List<String> sizesList;

  String get title => prodMap['title'];
  String get description => prodMap['description'];
  double get price {
    final value = prodMap['price'] ?? 0;
    return value / 100.0;
  }

  ProductPageMode get mode =>
      product == null ? ProductPageMode.newProd : ProductPageMode.editProd;
  ProductUpdateStatus updateStatus = ProductUpdateStatus.none;
}

enum ProductPageMode { newProd, editProd }
enum ProductUpdateStatus {
  none,
  deleting,
  successDeleting,
  failedDeleting,
  saving,
  successSaving,
  failedSaving
}
