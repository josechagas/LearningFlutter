import 'package:flutter/material.dart';
import 'package:virtual_store/router.dart';

typedef OnDrawerOptionSelected = Function(DrawerOption);

enum DrawerOption { homePage, products, findStore, myOrders }

class CustomDrawer extends StatelessWidget {

  CustomDrawer({Key key,@required this.selectedOption, @required this.didSelectOption}):super(key: key);

  final OnDrawerOptionSelected didSelectOption;
  final DrawerOption selectedOption;


  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 203, 236, 241),
          Colors.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
      ),
    );

    final drawer = Drawer(
      child: Container(
        decoration: boxDecoration,
        child: _buildDrawerListItems(context),
      ),
    );

    return drawer;
  }

  Widget _buildDrawerListItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: _buildDrawerHeader(context),
        ),
        _buildDrawerOptionItem(
          context,
          option: DrawerOption.homePage,
          title: 'Inicio',
          icon: Icons.home,
        ),
        _buildDrawerOptionItem(
          context,
          option: DrawerOption.products,
          title: 'Produtos',
          icon: Icons.list,
        ),
        _buildDrawerOptionItem(
          context,
          option: DrawerOption.findStore,
          title: 'Encontre uma loja',
          icon: Icons.location_on,
        ),
        _buildDrawerOptionItem(
          context,
          option: DrawerOption.myOrders,
          title: 'Meus Pedidos',
          icon: Icons.playlist_add_check,
        ),
      ],
    );
  }

  Widget _buildDrawerOptionItem(BuildContext context,
      {DrawerOption option, String title, IconData icon}) {

    return ListTile(
      selected: option == selectedOption,
      title:  Text(
        title,
        style: Theme.of(context).textTheme.subhead,
      ),
      leading: Icon(
        icon,
        size: 25,
      ),
      onTap: () {
        didSelectOption(option);
      },
    );

  }

  Widget _buildDrawerHeader(BuildContext context) {
    /*return DrawerHeader(
      child: ,
    );*/
    final col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            "Flutter's\nClothing",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Olá',
            style: Theme.of(context).textTheme.subhead,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Entre ou Cadastre-se',
                style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ],
          ),
        )
      ],
    );

    return col;
  }
}