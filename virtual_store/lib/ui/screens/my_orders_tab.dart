import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/my_orders_tab_bloc.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
import 'package:virtual_store/ui/widgets/load_info_widget.dart';
import 'package:virtual_store/ui/tiles/order_tile.dart';
import 'package:virtual_store/ui/widgets/user_not_logged_info_widget.dart';

class MyOrdersTab extends StatefulWidget {
  @override
  _MyOrdersTabState createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends State<MyOrdersTab> {
  MyOrdersTabBloc bloc;

  @override
  void initState() {
    bloc = MyOrdersTabBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*final bloc = Provider.of<UserBloc>(context, listen: false);
    if(bloc.isLoggedIn) {
      //user logged body
      return _buildUserLoggedBody(bloc);
    }
    else {
      //user not logged body
      return _buildUserNotLoggedBody(bloc);
    }*/
    return Consumer<UserBloc>(
      builder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context, UserBloc userBloc, child) {
    bloc.setUpFuture(userBloc);
    if (userBloc.isLoggedIn) {
      //user logged body
      return _buildUserLoggedBody(userBloc);
    } else {
      //user not logged body
      return _buildUserNotLoggedBody(userBloc);
    }
  }

  Widget _buildUserLoggedBody(UserBloc userBloc) {
    return FutureBuilder<QuerySnapshot>(
        future: bloc.ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.documents
                  .map((doc) => OrderTile(orderId: doc.documentID))
                  .toList().reversed.toList(),
            );
          }
          return LoadInfoWidget(
            hasError: snapshot.hasError,
            onReloadPressed: () {
              setState(() {
                bloc.reloadFuture(userBloc.user.uid);
              });
            },
          );
        });
  }

  Widget _buildUserNotLoggedBody(UserBloc bloc) {
    return UserNotLoggedInfoWidget(
      icon: Icons.view_list,
      message: 'Faça login para acompanhar!',
    );
  }
}
