import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class CategoryBloc
    extends Bloc<BlocEvent<CategoryBlocEvent>, CategoryBlocState> {
  CategoryBloc(CategoryBlocState initialState) : super(initialState);

  @override
  Stream<CategoryBlocState> mapEventToState(
      BlocEvent<CategoryBlocEvent> event) async* {
    switch (event.event) {
      case CategoryBlocEvent.save:
        if (state.hasChanges) {
          final newState = CategoryBlocState.fromState(state);
          newState.updateStatus = CategoryUpdateStatus.saving;
          yield newState;
          yield await _saveCategory();
        }
        break;
      case CategoryBlocEvent.delete:
        final newState = CategoryBlocState.fromState(state);
        newState.updateStatus = CategoryUpdateStatus.deleting;
        yield newState;
        yield await _deleteCategory();
        break;
      case CategoryBlocEvent.setImage:
        if (event.data != null) {
          final newState = CategoryBlocState.fromState(state);
          newState.setImageFile(event.data);
          yield newState;
        }
        break;
      case CategoryBlocEvent.setTitle:
        if (event.data != null) {
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

  Future<CategoryBlocState> _saveCategory() async {
    final Map<String,dynamic> dataToUpload =
        state.mode == CategoryBlocMode.edit ? state.category.data() : {};
    dataToUpload['title'] = state.title;
    if (state.iconFile != null) {
      StorageTaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('icons')
          .child(state.title)
          .putFile(state.iconFile)
          .onComplete;
      dataToUpload['icon'] = await snapshot.ref.getDownloadURL();
    }
    if (state.mode == CategoryBlocMode.create) {
      final docId = state.title.toLowerCase();
      return await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .set(dataToUpload)
          .then((value) async {
        final newCategory = await FirebaseFirestore.instance
            .collection('products')
            .doc(state.title.toLowerCase())
            .get();
        final newState = CategoryBlocState(category: newCategory);
        newState.updateStatus = CategoryUpdateStatus.successSaving;
        return newState;
      }).catchError((error) {
        final newState = CategoryBlocState.fromState(state);
        newState.updateStatus = CategoryUpdateStatus.failedSaving;
        return newState;
      });
    }
    return state;
  }

  Future<CategoryBlocState> _deleteCategory() async {
    if (state.category != null) {
      return await state.category.reference.delete().then((value) {
        final newState = CategoryBlocState.fromState(state);
        newState.updateStatus = CategoryUpdateStatus.successDeleting;
        return newState;
      })
          .catchError((error) {
        final newState = CategoryBlocState.fromState(state);
        newState.updateStatus = CategoryUpdateStatus.failedDeleting;
        return newState;
      });
      //final updateStatus =
    }
    return state;
  }
}

enum CategoryBlocEvent { save, delete, setImage, setTitle }

class CategoryBlocState {
  CategoryBlocState({this.category})
      : title = category?.data != null ? category?.data()['title'] : null,
        iconUrl = category?.data != null ? category?.data()['icon'] : null,
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

  bool get isAValidCategory =>
      (title != null && title.isNotEmpty) &&
      (iconFile != null || iconUrl != null);
  bool get hasChanges {
    if (mode == CategoryBlocMode.create) {
      return iconFile != null || title != null;
    }
    return iconFile != null ||
        (category != null && title != category.data()['title']);
  }

  CategoryBlocMode get mode =>
      category != null ? CategoryBlocMode.edit : CategoryBlocMode.create;
  CategoryUpdateStatus updateStatus = CategoryUpdateStatus.none;

  void setImageFile(File file) {
    iconFile = file;
    iconUrl = null;
  }
}

enum CategoryBlocMode { edit, create }

enum CategoryUpdateStatus {
  none,
  deleting,
  successDeleting,
  failedDeleting,
  saving,
  successSaving,
  failedSaving
}
