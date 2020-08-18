import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ClientsBloc extends Bloc<BlocEvent<ClientsBlocEvent>,ClientsBlocState>{

  ClientsBloc(ClientsBlocState initialState):super(initialState) {
    _addUsersListener();
  }

  StreamSubscription _usersListener;

  void dispose(){
    _usersListener.cancel();
  }

  @override
  Stream<ClientsBlocState> mapEventToState(BlocEvent<ClientsBlocEvent> event) async* {
    switch(event.event) {
      case ClientsBlocEvent.searchBy:
        break;
      case ClientsBlocEvent.udatesOnUsers:
        yield _updateStateForChanges(event.data);
        break;
      default:
        break;
    }
  }

  void _addUsersListener(){
    _usersListener = Firestore.instance.collection('users').snapshots().listen((snapshot) {
      add(BlocEvent(ClientsBlocEvent.updatesOnUsers, data: snapshot.documentChanges));
    });
  }

  ClientsBlocState _updateStateForChanges(List<DocumentChange> changes) {
    final newState = ClientsBlocState.fromState(state);
    changes.forEach((change) {
      String uid = change.document.documentID;
      switch(change.type){
        case DocumentChangeType.added:
          newState.users[uid] = change.document.data;
          break;
        case DocumentChangeType.modified:
          newState.users[uid].addAll(change.document.data);
          break;
        case DocumentChangeType.removed:
          newState.users.remove(uid);
          break;
      }
    });
    return newState;
  }
}

class ClientsBlocState {
  ClientsBlocState();

  factory ClientsBlocState.fromState(ClientsBlocState state){
    final newState = ClientsBlocState();
    newState.users = state.users;
    return newState;
  }

  Map<String, Map<String, dynamic>> users = {};

  List<Map<String, dynamic>> get usersList => users.values.toList();
}

enum ClientsBlocEvent {
  searchBy,
  updatesOnUsers
}