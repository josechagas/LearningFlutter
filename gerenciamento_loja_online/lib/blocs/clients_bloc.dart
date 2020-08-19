import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ClientsBloc extends Bloc<BlocEvent<ClientsBlocEvent>,ClientsBlocState>{

  ClientsBloc(ClientsBlocState initialState):super(initialState) {
    _addUsersListener();
    add(BlocEvent(ClientsBlocEvent.loadClients));
  }

  StreamSubscription _usersListener;

  @override
  Future<void> close() {
    _usersListener.cancel();
    return super.close();
  }

  @override
  Stream<ClientsBlocState> mapEventToState(BlocEvent<ClientsBlocEvent> event) async* {
    switch(event.event) {
      case ClientsBlocEvent.searchBy:
        yield await _searchClientsBy(event.data);
        break;
      case ClientsBlocEvent.updatesOnClients:
        yield _updateStateForChanges(event.data);
        break;
      case ClientsBlocEvent.loadClients:
        var newState = ClientsBlocState.fromState(state);
        newState.loadStatus = ClientsLoadStatus.loading;
        yield newState;
        yield await _loadClients();
        break;
      default:
        break;
    }
  }

  void _addUsersListener(){
    _usersListener = Firestore.instance.collection('users').snapshots().listen((snapshot) {
      add(BlocEvent(ClientsBlocEvent.updatesOnClients, data: snapshot.documentChanges));
    });
  }

  Future<ClientsBlocState> _searchClientsBy(String searchString) async {
    if(searchString.trim().isEmpty) {
      return _loadClients();
    }
    else {
      var newState = ClientsBlocState.fromState(state);
      newState.users.removeWhere((key, value) => !value['name'].toUpperCase().contains(searchString.toUpperCase()));
      newState.loadStatus = ClientsLoadStatus.success;
      return newState;
    }
  }

  Future<ClientsBlocState> _loadClients() async {
    var newState = ClientsBlocState.fromState(state);
    return await Firestore.instance.collection('users').getDocuments().then((docs) {
      newState.users = { for (var snapshot in docs.documents) snapshot.documentID : snapshot.data };
      newState.loadStatus = ClientsLoadStatus.success;
      return newState;
    }).catchError((error){
      newState.loadStatus = ClientsLoadStatus.failedToLoad;
      return newState;
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
    newState.loadStatus = state.loadStatus;
    return newState;
  }

  Map<String, Map<String, dynamic>> users = {};
  List<Map<String, dynamic>> get usersList => users.values.toList();
  ClientsLoadStatus loadStatus = ClientsLoadStatus.none;
}

enum ClientsBlocEvent {
  searchBy,
  updatesOnClients,
  loadClients
}

enum ClientsLoadStatus {
  loading,
  none,
  success,
  failedToLoad
}