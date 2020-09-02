import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class CategoryBloc extends Bloc<BlocEvent<CategoryBlocEvent>, CategoryBlocState> {

  CategoryBloc(CategoryBlocState initialState):super(initialState);

  @override
  Stream<CategoryBlocState> mapEventToState(BlocEvent<CategoryBlocEvent> event) {
    switch(event.event) {
      case CategoryBlocEvent.save:
        // TODO: Handle this case.
        break;
      case CategoryBlocEvent.delete:
        // TODO: Handle this case.
        break;
      default:
        break;
    }
  }

}

enum CategoryBlocEvent {
  save, delete
}

class CategoryBlocState {

  CategoryBlocState({this.category});
  factory CategoryBlocState.fromState(CategoryBlocState state) => CategoryBlocState(
    category: state.category,
  );

  DocumentSnapshot category;

  String get title => category?.data != null ? category?.data['title'] : null;
  String get iconUrl => category?.data != null ? category?.data['icon'] : null;
  File iconFile;
  CategoryBlocMode get mode => category != null ? CategoryBlocMode.edit : CategoryBlocMode.create;

  CategoryUpdateStatus updateStatus = CategoryUpdateStatus.none;
}

enum CategoryBlocMode {
  edit, create
}

enum CategoryUpdateStatus {
  none,
  deleting,
  successDeleting,
  failedDeleting,
  saving,
  successSaving,
  failedSaving
}