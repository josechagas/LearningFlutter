import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ClientTileBloc extends Bloc<BlocEvent<ClientTileBlocEvents>, ClientTileBlocState>{

  ClientTileBloc(ClientTileBlocState initialState) : super(initialState);

  @override
  Stream<ClientTileBlocState> mapEventToState(BlocEvent<ClientTileBlocEvents> event) async* {

    switch(event.event) {
      case ClientTileBlocEvents.loadOrdersIfNeeded:
        if([LoadOrdersStatus.failed, LoadOrdersStatus.none].contains(state.loadOrdersStatus)) {
          var newState = ClientTileBlocState.fromState(state);
          newState.loadOrdersStatus = LoadOrdersStatus.loading;
          yield newState;
          yield await loadUserOrders(); 
        }
        break;
    }
  }

  Future<ClientTileBlocState> loadUserOrders() async {
    var newState = ClientTileBlocState.fromState(state);
    return await Firestore.instance.collection('users/${state.userId}/orders').getDocuments().then((documents){
      newState.user['orders'] = documents.documents.map((e) => e.data);
      newState.loadOrdersStatus = LoadOrdersStatus.success;
      return newState;
    }).catchError((error){
      newState.loadOrdersStatus = LoadOrdersStatus.failed;
      return newState;
    });
  }

}

class ClientTileBlocState {
  ClientTileBlocState(this.user, this.userId);
  factory ClientTileBlocState.fromState(ClientTileBlocState state) {
    var newState = ClientTileBlocState(state.user, state.userId);
    newState.loadOrdersStatus = state.loadOrdersStatus;
    return newState;
  }
  Map<String, dynamic> user = {};
  String userId;
  LoadOrdersStatus loadOrdersStatus = LoadOrdersStatus.none;
}

enum ClientTileBlocEvents {
  loadOrdersIfNeeded,
}

enum LoadOrdersStatus {
  none,
  loading,
  success,
  failed
}