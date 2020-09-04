import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class CategoryBloc extends Bloc<BlocEvent<CategoryBlocEvent>, CategoryBlocState> {

  CategoryBloc(CategoryBlocState initialState):super(initialState);

  @override
  Stream<CategoryBlocState> mapEventToState(BlocEvent<CategoryBlocEvent> event) async* {
    switch(event.event) {
      case CategoryBlocEvent.save:
        // TODO: Handle this case.
        break;
      case CategoryBlocEvent.delete:
        // TODO: Handle this case.
        break;
      case CategoryBlocEvent.setImage:
        if(event.data != null) {
          final newState = CategoryBlocState.fromState(state);
          newState.setImageFile(event.data);
          yield newState;
        }
        break;
      case CategoryBlocEvent.setTitle:
        if(event.data != null) {
          final newState = CategoryBlocState.fromState(state);
          newState.title = event.data;
          yield newState;
        }
        break;
      default:
        break;
    }
  }

  bool validateCategoryTitle(String title) {
    return title != null && title.isNotEmpty;
  }
}

enum CategoryBlocEvent {
  save, delete, setImage, setTitle
}

class CategoryBlocState {

  CategoryBlocState({this.category})
      : title = category?.data != null ? category?.data['title'] : null,
        iconUrl = category?.data != null ? category?.data['icon'] : null,
        iconFile = null;

  factory CategoryBlocState.fromState(CategoryBlocState state) {
    final newState = CategoryBlocState(
      category: state.category,
    );
    newState.iconFile = state.iconFile;
    newState.title = state.title;
    return newState;
  }

  DocumentSnapshot category;

  String title;
  String iconUrl;
  File iconFile;
  bool get isAValidCategory => (title != null && title.isNotEmpty) && (iconFile != null || iconUrl != null);
  CategoryBlocMode get mode => category != null ? CategoryBlocMode.edit : CategoryBlocMode.create;
  CategoryUpdateStatus updateStatus = CategoryUpdateStatus.none;

  void setImageFile(File file){
    iconFile = file;
    iconUrl = null;
  }
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