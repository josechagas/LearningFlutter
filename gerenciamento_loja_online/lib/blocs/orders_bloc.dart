import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class OrdersBloc extends Bloc<BlocEvent<OrdersBlocEvents>, OrdersBlocState> {
  OrdersBloc(OrdersBlocState initialState) : super(initialState) {
    _addOrdersListener();
  }

  StreamSubscription _ordersListener;


  @override
  Stream<OrdersBlocState> mapEventToState(
      BlocEvent<OrdersBlocEvents> event) async* {
    switch (event.event) {
      case OrdersBlocEvents.loadOrders:
        final newState = OrdersBlocState.fromState(state);
        newState.loadStatus = OrdersLoadStatus.loading;
        yield newState;
        yield await _loadOrders();
        break;
      case OrdersBlocEvents.orderBy:
        final newState = OrdersBlocState.fromState(state);
        newState.sortOrdersBy(event.data ?? SortCriteria.readyFirst);
        yield newState;
        break;
      case OrdersBlocEvents.updatesOnOrders:
        yield _updateStateForChanges(event.data);
        break;
    }
  }

  @override
  Future<void> close() {
    _ordersListener.cancel();
    return super.close();
  }

  Future<OrdersBlocState> _loadOrders() async {
    final newState = OrdersBlocState.fromState(state);
    return await Firestore.instance.collection('orders').getDocuments().then((data) {
      newState.orders = data.documents;
      newState.loadStatus = OrdersLoadStatus.success;
      newState.sortOrdersByCurrentCriteria();
      return newState;
    }).catchError((error){
      newState.loadStatus = OrdersLoadStatus.failed;
      newState.orders = [];
      return newState;
    });
  }

  OrdersBlocState _updateStateForChanges(List<DocumentChange> changes) {
    final newState = OrdersBlocState.fromState(state);
    changes.forEach((change) {
      String orderId = change.document.documentID;
      switch (change.type) {
        case DocumentChangeType.added:
          newState.orders.add(change.document);
          break;
        case DocumentChangeType.modified:
          newState.orders
              .removeWhere((element) => element.documentID == orderId);
          newState.orders.add(change.document);
          break;
        case DocumentChangeType.removed:
          newState.orders
              .removeWhere((element) => element.documentID == orderId);
          break;
      }
    });
    newState.loadStatus = OrdersLoadStatus.success;
    newState.sortOrdersByCurrentCriteria();
    return newState;
  }



  void _addOrdersListener() {
    _ordersListener =
        Firestore.instance.collection('orders').snapshots().listen((snapshot) {
      add(BlocEvent(OrdersBlocEvents.updatesOnOrders,
          data: snapshot.documentChanges));
    });
  }
}

enum OrdersBlocEvents { loadOrders, updatesOnOrders, orderBy }

class OrdersBlocState {
  OrdersBlocState();
  OrdersBlocState.loadOrders() {
    loadStatus = OrdersLoadStatus.loading;
  }

  factory OrdersBlocState.fromState(OrdersBlocState state) {
    final newState = OrdersBlocState();
    newState.loadStatus = state.loadStatus;
    newState.orders = state.orders;
    return newState;
  }

  List<DocumentSnapshot> orders = [];
  OrdersLoadStatus loadStatus = OrdersLoadStatus.none;
  SortCriteria criteria = SortCriteria.readyFirst;

  void sortOrdersBy(SortCriteria criteria) {
    this.criteria = criteria;
    orders.sort((a,b){
      int statusA = a.data['status'];
      int statusB = b.data['status'];
      if(statusA < statusB){
        return criteria == SortCriteria.readyFirst ? 1 : -1;
      }
      else if(statusA > statusB){
        return criteria == SortCriteria.readyFirst ? -1 : 1;
      }
      return 0;
    });
  }

  void sortOrdersByCurrentCriteria() {
    sortOrdersBy(criteria);
  }
}

enum OrdersLoadStatus { none, loading, success, failed }

enum SortCriteria {readyFirst, readyLast}