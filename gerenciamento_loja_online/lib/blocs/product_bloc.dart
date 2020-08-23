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
  save
}

class ProductBlocState {
  ProductBlocState({this.categoryId, this.product});
  String categoryId;
  DocumentSnapshot product;
  ProductPageMode get mode => product == null ? ProductPageMode.newProd : ProductPageMode.editProd;

  ProductSaveStatus saveStatus = ProductSaveStatus.none;
}

enum ProductPageMode { newProd, editProd }
enum ProductSaveStatus { none, saving, success, failed }
