import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_contatos/blocs/my_home_page_bloc.dart';
import 'package:lista_contatos/helpers/contact_helper.dart';
import 'package:lista_contatos/ui/contact_bottom_sheet_options.dart';
import 'package:lista_contatos/ui/contact_page.dart';

enum OrderOptions { aToz, zToa }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyHomePageBloc bloc = MyHomePageBloc();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bloc.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contatos"),
        actions: <Widget>[
          _buildOrderByWidget(),
        ],
      ),
      body: ValueListenableBuilder<Future<List<Contact>>>(
        valueListenable: bloc.contactsFuture,
        builder: (
            BuildContext context,
            Future<List<Contact>> contactsFuture,
            Widget child){
          return FutureBuilder(
            future: contactsFuture,
            initialData: bloc.contacts.value,
            builder: _buildFutureBody,
          );
        },
      ),
      floatingActionButton: _buildAddContactButton(),
    );
  }

  Widget _buildFutureBody(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      //return list of contacts
      return _buildContactsListView();
    } else if (snapshot.hasError) {
      //return error callback
      return Center(
        child: Text("Ocorreu um erro durante o carregamento dos dados."),
      );
    } else {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
        case ConnectionState.active:
          return Center(
            child: CircularProgressIndicator(),
          );
        default:
          return Center(
            child: Text(
              "Sem contatos",
            ),
          );
      }
    }
  }

  Widget _buildContactsListView() {
    return ValueListenableBuilder(
      valueListenable: bloc.contacts,
      builder: (context,List<Contact> contacts,child){
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contacts?.length ?? 0,
          itemBuilder: _buildListViewItem,
        );
      },
    );
  }

  Widget _buildOrderByWidget() {
    return PopupMenuButton<OrderOptions>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<OrderOptions>>[
          const PopupMenuItem<OrderOptions>(
            child: Text(
              "Ordenar de A a Z",
            ),
            value: OrderOptions.aToz,
          ),
          const PopupMenuItem<OrderOptions>(
            child: Text(
              "Ordenar de Z a A",
            ),
            value: OrderOptions.zToa,
          )
        ];
      },
      onSelected: _onPopupMenuItemSelected,
    );
  }

  Widget _buildAddContactButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: _onAddContactButtonPressed,
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    final contact = bloc.getContactAt(index) ??
        Contact(name: "Contato", phone: "", img: null, email: "");
    contact.img = null;

    final content = ListTile(
      isThreeLine: true,
      title: Text(
        contact.name,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            contact.email,
          ),
          Text(contact.phone)
        ],
      ),
      leading: _buildLeadingItem(contact),
      onTap: () => _onContactTap(index: index),
    );

    return Card(
      child: content,
    );
  }

  Widget _buildLeadingItem(Contact contact) {
    final hasImg = contact.img?.isNotEmpty ?? false;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: hasImg
              ? FileImage(File(contact.img))
              : AssetImage("images/user.png"),
        ),
      ),
    );
  }

  void _onPopupMenuItemSelected(OrderOptions choosed) {
    bloc.orderContactsBy(choosed);
  }

  void _onContactTap({@required int index}) {
    Contact contact = bloc.getContactAt(index);
    if (contact == null) return;

    //iOS Action sheet
    /*
    showCupertinoModalPopup(
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              "Escolha uma opção",
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  "Ligar",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {},
              ),
              CupertinoActionSheetAction(
                child: Text(
                  "Editar",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {},
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                child: Text(
                  "Exluir",
                ),
                onPressed: () {},
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              isDefaultAction: true,
              onPressed: () {},
            ),
          );
        },
        context: context,
        useRootNavigator: true);
*/

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return ContactBottomSheetOptions(
              contact: contact,
              editOptionFuction: (Contact c) {
                Navigator.of(context).pop();
                _showContactPage(contact: c);
              },
              onAfterDeleteOption: (Contact c, success) {
                reloadContacts();
                _showDeletionSnackbar(success: success);
              },
            );
          },
        );
      },
    );
  }

  void _onAddContactButtonPressed() {
    _showContactPage();
  }

  void _showContactPage({Contact contact}) async {
    final hasUpdates = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ContactPage(
        contact: contact,
      );
    }));

    if (hasUpdates != null && hasUpdates) {
      _showResultSnackbar(
        success: hasUpdates,
      );

      if (hasUpdates) {
        reloadContacts();
      }
    }
  }

  void _showResultSnackbar({bool success = true}) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          Text(success ? "Contato salvo com sucesso!!" : "Falha em salvar!!"),
        ],
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _showDeletionSnackbar({bool success = true}) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          Text(success
              ? "Contato excluido com sucesso!!"
              : "Falha em excluir!!"),
        ],
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void reloadContacts() {
    bloc.loadContacts();
  }
}
