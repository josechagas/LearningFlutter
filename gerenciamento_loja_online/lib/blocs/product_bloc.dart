import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ProductBloc extends Bloc<BlocEvent<ProductBlocEvent>,ProductBlocState> {
  ProductBloc(ProductBlocState initialState) : super(initialState);

  @override
  Stream<ProductBlocState> mapEventToState(BlocEvent<ProductBlocEvent> event) async* {
    switch(event.event) {
      case ProductBlocEvent.save:
        final newState = ProductBlocState.fromState(state);
        newState.saveStatus = ProductSaveStatus.saving;
        yield newState;
        yield await _saveChanges(event.data);
        break;
      case ProductBlocEvent.delete:
        break;
      default:
        break;
    }
  }

  Future<ProductBlocState> _saveChanges(Map<String,dynamic> data) async {
    data['price'] *= 100.0;
    final newState = ProductBlocState.fromState(state);
    newState.saveStatus = ProductSaveStatus.success;
    await Future.delayed(Duration(seconds: 5));
    return newState;
  }

  Future<void> _uploadImages() async {
    final String docId = state.product.documentID;
    state.imagesList.
  }
}

enum ProductBlocEvent {
  save,
  delete
}

class ProductBlocState {
  ProductBlocState({this.categoryId, this.product}) {
    sizesList = List.from(prodMap['sizes'] ?? []);
    imagesList = List.from(prodMap['images'] ?? []);
  }

  factory ProductBlocState.fromState(ProductBlocState state) => ProductBlocState(
    product: state.product,
    categoryId: state.categoryId,
  );

  String categoryId;

  DocumentSnapshot product;
  Map<String,dynamic> get prodMap => product != null ? Map.of(product.data) : {};

  List<String> imagesList;
  List<String> sizesList;

  String get title => prodMap['title'];
  String get description => prodMap['description'];
  double get price {
    final value = prodMap['price'] ?? 0;
    return value/100.0;
  }

  ProductPageMode get mode => product == null ? ProductPageMode.newProd : ProductPageMode.editProd;
  ProductSaveStatus saveStatus = ProductSaveStatus.none;
}

enum ProductPageMode { newProd, editProd }
enum ProductSaveStatus { none, saving, success, failed }
