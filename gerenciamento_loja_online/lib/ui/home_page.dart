import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/clients_bloc.dart';
import 'package:gerenciamento_loja_online/ui/clients_page/clients_page.dart';
import 'package:gerenciamento_loja_online/ui/orders_page/orders_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  List<Widget> pages = <Widget>[];

  @override
  void initState() {
    _buildPagesWidgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widget = pages[_selectedTab];
    return Scaffold(
      body: BlocProvider<ClientsBloc>(
        create: (context) => ClientsBloc(ClientsBlocState.loadUsers()),
        child: Container(
          color: Colors.grey[850],
          alignment: Alignment.center,
          child: SafeArea(
            child: widget,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedTab,
        onTap: _onNavItemTapped,
        items: [
          _buildNavBarItem(
            title: 'Clientes',
            icon: Icons.person,
          ),
          _buildNavBarItem(
              icon: Icons.shopping_cart,
              title: 'Pedidos',
          ),
          _buildNavBarItem(
              icon: Icons.list,
              title: 'Produtos',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem({@required IconData icon, @required String title}){
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
      ),
      title: Text(
        title
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void _buildPagesWidgets(){
    pages.add(ClientsPage());
    pages.add(OrdersPage());
    pages.add(Text(
      'Selected Tab: 3',
    ));
  }
}
