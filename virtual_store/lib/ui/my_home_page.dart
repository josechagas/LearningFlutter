import 'package:flutter/material.dart';
import 'package:virtual_store/router.dart';

class MyHomePage extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final router = DrawerRouter();
  ValueNotifier<int> currentDrawerItem = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 118, 130),
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: currentDrawerItem,
          builder: (BuildContext context, int value, Widget child) {
            return Text(
              appBarTitleForSelectedDrawer(value),
            );
          },
        ),
      ),
      body: _buildDrawerNavigator(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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

  Widget _buildDrawerListItems(BuildContext context){
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: _buildDrawerHeader(context),
        ),
        _buildDrawerOptionItem(
          context,
          title: 'Inicio',
          icon: Icons.home,
          onTap: ()=>_goToHome(context),
        ),
        _buildDrawerOptionItem(
          context,
          title: 'Produtos',
          icon: Icons.list,
          onTap: ()=>_goToProducts(context),
        ),
        _buildDrawerOptionItem(
          context,
          title: 'Encontre uma loja',
          icon: Icons.location_on,
          onTap: ()=>_goToFindAStore(context),
        ),
        _buildDrawerOptionItem(
          context,
          title: 'Meus Pedidos',
          icon: Icons.playlist_add_check,
          onTap: ()=>_goToMyOrders(context),
        ),
      ],
    );
  }

  Widget _buildDrawerOptionItem(
      BuildContext context,
  {String title, IconData icon, Function onTap}
      ){
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.subhead,
      ),
      leading: Icon(
        icon,
        size: 25,
      ),
      onTap: onTap,
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
            style: Theme.of(context).textTheme.subtitle,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Entre ou Cadastre-se',
                style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              Icon(
                Icons.arrow_forward,
                  color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        )
      ],
    );

    return col;
  }

  Widget _buildDrawerNavigator(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: DrawerRouter.homePage,
      onGenerateRoute: router.generateRoute,
    );
  }

  void _goToHome(BuildContext context) {
    currentDrawerItem.value = 0;
    navigatorKey.currentState.pushNamed(DrawerRouter.homePage);
    Navigator.of(context).pop();
  }

  void _goToProducts(BuildContext context) {
    currentDrawerItem.value = 1;
    navigatorKey.currentState.pushNamed(DrawerRouter.homePage2);
    Navigator.of(context).pop();
  }

  void _goToFindAStore(BuildContext context) {
    currentDrawerItem.value = 2;
    //navigatorKey.currentState.pushNamed(DrawerRouter.homePage2);
    Navigator.of(context).pop();
  }

  void _goToMyOrders(BuildContext context) {
    currentDrawerItem.value = 3;
    //navigatorKey.currentState.pushNamed(DrawerRouter.homePage2);
    Navigator.of(context).pop();
  }

  void _onSignInButtonPressed(){

  }

  String appBarTitleForSelectedDrawer(int item) {
    switch (item) {
      case 0:
        return 'Novidades';
      case 1:
        return 'Home Page 2';
      default:
        return "Flutter's Clothing";
    }
  }

  /*
  Widget _buildNestedScrollViewBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: Color.fromARGB(255, 211, 118, 130),
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            title: ValueListenableBuilder(
              valueListenable: currentDrawerItem,
              builder: (BuildContext context, int value, Widget child) {
                return Text(
                  appBarTitleForSelectedDrawer(value),
                );
              },
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child:LimitedBox(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
            child: _buildDrawerNavigator(context),
          ),
        )
      ],
    );
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
        return [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Color.fromARGB(255, 211, 118, 130),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: ValueListenableBuilder(
                valueListenable: currentDrawerItem,
                builder: (BuildContext context, int value, Widget child) {
                  return Text(
                    appBarTitleForSelectedDrawer(value),
                  );
                },
              ),
              centerTitle: true,
            ),
          )
        ];
      },
      body: _buildDrawerNavigator(context),
    );
  }
*/
}
