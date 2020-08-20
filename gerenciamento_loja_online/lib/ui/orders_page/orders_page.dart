import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/orders_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';
import 'package:gerenciamento_loja_online/ui/orders_page/order_tile.dart';

class OrdersPage extends StatelessWidget {

  final bloc = OrdersBloc(OrdersBlocState.loadOrders());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<OrdersBloc, OrdersBlocState>(
        cubit: bloc,
        builder: (context, state){
          switch(state.loadStatus) {
            case OrdersLoadStatus.loading:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              );
            case OrdersLoadStatus.failed:
              return _buildFailedToLoad(context);
            case OrdersLoadStatus.success:
              if(state.orders.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum pedido encontrado!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                );
              }
              else {
                return _buildOrdersList(state);
              }
              break;
            default:
              break;
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFailedToLoad(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ocorreu um erro em carregar os pedidos!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          child: Text(
            'Recarregar',
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: ()=> bloc.add(BlocEvent(OrdersBlocEvents.loadOrders)),
        ),
      ],
    );
  }

  Widget _buildOrdersList(OrdersBlocState state){
    return ListView.builder(
      itemCount: state.orders.length,
      itemBuilder: (context, index) {
        return OrderTile(
          order: state.orders[index],
        );
      },
    );
  }
}
