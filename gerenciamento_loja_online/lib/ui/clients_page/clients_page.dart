import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/clients_bloc.dart';
import 'package:gerenciamento_loja_online/ui/clients_page/client_tile.dart';

class ClientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClientsBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            textInputAction: TextInputAction.search,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
          ),
        ),
        Expanded(
          child: BlocBuilder<ClientsBloc, ClientsBlocState>(
            cubit: bloc,
            builder: (context, state) {
              switch (state.loadStatus) {
                case ClientsLoadStatus.loading:
                  return Container(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    ),
                  );
                case ClientsLoadStatus.none:
                  return SizedBox.shrink();
                case ClientsLoadStatus.success:
                  if (state.usersList.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum cliente encontrado!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    );
                  }
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return ClientTile(state.usersList[index],state.users.keys.toList()[index]);
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white38,
                      ),
                      itemCount: state.usersList?.length ?? 0
                  );
                case ClientsLoadStatus.failedToLoad:
                  return Center(
                    child: Text(
                      'Não foi possível carregar os clientes!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  );
                default:
                  return SizedBox.shrink();
              }
            },
          ),
        )
      ],
    );
  }
}
