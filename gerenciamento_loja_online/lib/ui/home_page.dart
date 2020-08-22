import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/clients_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/orders_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';
import 'package:gerenciamento_loja_online/ui/clients_page/clients_page.dart';
import 'package:gerenciamento_loja_online/ui/orders_page/orders_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciamento_loja_online/ui/products_page/products_page.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClientsBloc(ClientsBlocState.loadUsers()),
        ),
        BlocProvider(
          create: (context) => OrdersBloc(OrdersBlocState.loadOrders()),
        )
      ],
      child: Builder(
        builder: (context){//to make possible FloatingButton access OrdersBloc
          return Scaffold(
            body:Container(
              color: Colors.grey[850],
              alignment: Alignment.center,
              child: SafeArea(
                child: widget,
              ),
            ),
            floatingActionButton: _buildFloating(context),
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
        },
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

  Widget _buildFloating(BuildContext context){//this context contain OrdersBloc
    switch(_selectedTab){
      case 1:
        return SpeedDial(
          child: Icon(
            Icons.sort,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          overlayOpacity:  0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              label: 'Concluidos Abaixo',
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              onTap: () => _updateOrdersSortBy(SortCriteria.readyLast, context),
            ),
            SpeedDialChild(
              child: Icon(
                Icons.arrow_upward,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              label: 'Concluidos Acima',
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              onTap: () => _updateOrdersSortBy(SortCriteria.readyFirst, context),
            ),
          ],
        );
        break;
      case 2:
      default:
        break;
    }
    return null;
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void _buildPagesWidgets(){
    pages.add(ClientsPage());
    pages.add(OrdersPage());
    pages.add(ProductsPage());
  }

  void _updateOrdersSortBy(SortCriteria criteria,BuildContext context){
    final bloc = BlocProvider.of<OrdersBloc>(context);
    bloc.add(BlocEvent(OrdersBlocEvents.orderBy,data: criteria));
  }
}
