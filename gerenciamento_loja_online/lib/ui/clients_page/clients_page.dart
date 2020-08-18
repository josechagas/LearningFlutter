import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/ui/clients_page/client_tile.dart';

class ClientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
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
          child: ListView.separated(
              itemBuilder: (context, index){
                return ClientTile();
              }, separatorBuilder: (context, index)=> Divider(
            color: Colors.white38,
          ), itemCount: 10),
        )
      ],
    );
  }

}
