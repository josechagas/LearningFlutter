import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store/blocs/user_bloc.dart';

class MyOrdersTabBloc {

  Future<QuerySnapshot> ordersFuture;
  String userId;

  void setUpFuture(UserBloc bloc){
    if(bloc.isLoggedIn && (ordersFuture == null || bloc.user.uid != userId)){
      ordersFuture = _buildFuture(bloc.user.uid);
      userId = bloc.user.uid;
    }
  }

  void reloadFuture(String userId){
    ordersFuture = _buildFuture(userId);
  }

  Future<QuerySnapshot> _buildFuture(String userId){
    return Firestore.instance.collection('users').document(userId).collection('orders').getDocuments();
  }
}