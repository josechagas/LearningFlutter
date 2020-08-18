import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/client_tile_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';

class ClientTile extends StatelessWidget {

  ClientTile(Map<String, dynamic> user, String userId, {Key key}):
        bloc = ClientTileBloc(ClientTileBlocState(user, userId)),
        super(key: key){
    bloc.add(BlocEvent(ClientTileBlocEvents.loadOrdersIfNeeded));
  }

  final ClientTileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientTileBloc, ClientTileBlocState>(
      cubit: bloc,
      builder: (context, state){
        final user = state.user;
        final ordersCount = state.loadOrdersStatus == LoadOrdersStatus.loading ? '...' : '${user['orders']?.length ?? 0}';
        return ListTile(
          title: _buildLine(
            context,
            titleOne: user['name'],
            titleTwo: 'Pedidos: $ordersCount',
          ),
          subtitle: _buildColumn(
            context,
            titleOne: user['email'],
            titleTwo: user['address'],
          ),
        );
      },
    );
  }

  Widget _buildLine(BuildContext context, {@required String titleOne, @required titleTwo}) {
    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
      color: Colors.white,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
              titleOne,
            style: textStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            titleTwo,
            textAlign: TextAlign.right,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, {@required String titleOne, @required titleTwo}) {
    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
      color: Colors.white,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          titleOne,
          style: textStyle,
        ),
        Text(
          titleTwo,
          style: textStyle.copyWith(
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
