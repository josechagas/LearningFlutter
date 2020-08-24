import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ProductBloc extends Bloc<BlocEvent<ProductBlocEvent>,ProductBlocState> {


  ProductBloc(ProductBlocState initialState) : super(initialState);

  @override
  Stream<ProductBlocState> mapEventToState(BlocEvent<ProductBlocEvent> event) async* {
    // TODO: implement mapEventToState
    yield state;
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
