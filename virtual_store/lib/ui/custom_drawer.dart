import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/blocs/user_bloc.dart';
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
        _buildLoggedUserInfoWidget(),
      ],
    );

    return col;
  }

  Widget _buildLoggedUserInfoWidget(){
    return Consumer<UserBloc>(
      builder: (context, bloc, child){
        String userName = '';
        if(bloc.isLoggedIn) {
          userName = bloc.user.displayName;
        }

        return ListTile(
          title: Text(
            'Olá'+' $userName',
            style: Theme.of(context).textTheme.subhead,
          ),
          subtitle: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  bloc.isLoggedIn ? 'Sair' : 'Entre ou Cadastre-se',
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
            onTap: ()=> bloc.isLoggedIn ? _performSignOut(bloc) : _goToSignInPage(context),
          ),
        );
      },
    );

    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        String userName = '';
        bool isLogged = snapshot.hasData;
        if(isLogged) {
          userName = snapshot.data.displayName;
        }

        return ListTile(
          title: Text(
            'Olá'+' $userName',
            style: Theme.of(context).textTheme.subhead,
          ),
          subtitle: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  isLogged ? 'Sair' : 'Entre ou Cadastre-se',
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
            onTap: ()=>_goToSignInPage(context),
          ),
        );
      },
    );
  }


  void _goToSignInPage(BuildContext context){
    Navigator.of(context,rootNavigator: true).pushNamed(RootRouter.signIn);
  }

  void _performSignOut(UserBloc bloc){
    bloc.signOut();
  }

}