import 'package:flutter/material.dart';
import 'package:virtual_store/router.dart';
import 'package:virtual_store/ui/widgets/cart_floating_button.dart';
import 'package:virtual_store/ui/widgets/custom_drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final router = DrawerRouter();
  ValueNotifier<DrawerOption> currentDrawerItem = ValueNotifier(DrawerOption.homePage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ValueListenableBuilder(
        valueListenable: currentDrawerItem,
        builder: (context, value, child) {
          return CustomDrawer(
            selectedOption: value,
            didSelectOption: (option) => _onDrawerOptionSelected(option),
          );
        },
      ),
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 211, 118, 130),
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: currentDrawerItem,
          builder: (BuildContext context, DrawerOption value, Widget child) {
            return Text(
              appBarTitleForSelectedDrawer(value),
            );
          },
        ),
      ),
      body: _buildDrawerNavigator(context),
      floatingActionButton: CartFloatingButton(),
    );
  }

  Widget _buildDrawerNavigator(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: DrawerRouter.homePage,
      onGenerateRoute: router.generateRoute,
    );
  }

  void _onDrawerOptionSelected(DrawerOption option) {
    switch (option) {
      case DrawerOption.homePage:
        _goToHome(context);
        break;
      case DrawerOption.myOrders:
        _goToMyOrders(context);
        break;
      case DrawerOption.findStore:
        _goToFindAStore(context);
        break;
      case DrawerOption.products:
        _goToProducts(context);
        break;
    }
  }

  void _goToHome(BuildContext context) {
    currentDrawerItem.value = DrawerOption.homePage;
    navigatorKey.currentState.pushReplacementNamed(DrawerRouter.homePage);
    Navigator.of(context).pop();
  }

  void _goToProducts(BuildContext context) {
    currentDrawerItem.value = DrawerOption.products;
    navigatorKey.currentState.pushReplacementNamed(DrawerRouter.products);
    Navigator.of(context).pop();
  }

  void _goToFindAStore(BuildContext context) {
    currentDrawerItem.value = DrawerOption.findStore;
    navigatorKey.currentState.pushReplacementNamed(DrawerRouter.findStore);
    Navigator.of(context).pop();
  }

  void _goToMyOrders(BuildContext context) {
    currentDrawerItem.value = DrawerOption.myOrders;
    navigatorKey.currentState.pushReplacementNamed(DrawerRouter.myOrders);
    Navigator.of(context).pop();
  }

  String appBarTitleForSelectedDrawer(DrawerOption item) {
    switch (item) {
      case DrawerOption.homePage:
        return 'Novidades';
      case DrawerOption.products:
        return 'Produtos';
      case DrawerOption.myOrders:
        return 'Meus Pedidos';
      case DrawerOption.findStore:
        return 'Lojas';
      default:
        return "Flutter's Clothing";
    }
  }
}
