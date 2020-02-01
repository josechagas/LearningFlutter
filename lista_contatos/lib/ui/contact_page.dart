import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_contatos/blocs/contact_page_bloc.dart';
import 'package:lista_contatos/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  ContactPage({this.contact});
  final Contact contact;

  @override
  _ContactPageState createState() =>
      _ContactPageState(ContactPageBloc(contact: contact));
}

class _ContactPageState extends State<ContactPage> {
  _ContactPageState(this.bloc);
  ContactPageBloc bloc;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactFormKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = bloc.name;
    _emailController.text = bloc.email;
    _phoneController.text = bloc.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            bloc.name ?? "Novo Contato",
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: _buildBody(),
        ),
        floatingActionButton: _buildSaveButton(),
      ),
      onWillPop: _onWillPop,
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildContactImageWidget(),
        _buildContactFormWidget(),
      ],
    );
  }

  Widget _buildContactImageWidget() {
    final hasImage = bloc.img?.isNotEmpty ?? false;
    final side = 120.0;

    return MaterialButton(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Container(
          color: Colors.grey[200],
          child: Image(
            width: 120,
            height: 120,
            image: hasImage
                ? FileImage(File(bloc.img))
                : AssetImage("images/user.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onPressed: () => _onContactImageWidgetPressed(),
    );
  }

  Widget _buildContactFormWidget() {
    return Form(
      key: _contactFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Nome",
            ),
            controller: _nameController,
            validator: _validateName,
            onSaved: _onSaveName,
            onChanged: (String value) => _setUserEdited(),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Email",
            ),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onSaved: _onSaveEmail,
            onChanged: (String value) => _setUserEdited(),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Telefone",
            ),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            onSaved: _onSavePhone,
            onChanged: (String value) => _setUserEdited(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.save,
      ),
      onPressed: _onSaveButtonPressed,
    );
  }

  void _setUserEdited() => bloc.userEdited = true;

  void _onContactImageWidgetPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(image != null){
      setState(()=> bloc.img = image.path);
    }
  }

  Future<bool> _onWillPop() {
    if(bloc.userEdited) {
      //asks if wants to save
      showConfirmationAlertDialog();
      return Future.value(false);
    }
    else {
      return Future.value(true);
    }
    //return true;
  }

  void showConfirmationAlertDialog(){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      final alert = CupertinoAlertDialog(
        title: Text("Descartar alterações"),
        content: Text("Se sair as alterações serão perdidas."),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "Cancelar",
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(
              "Sim",
            ),
            onPressed: () {
              //Navigator.of(context).popUntil(predicate); better solution, but with named routes
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);//does not have changes
            },
          )
        ],
      );
      return alert;
    });
  }

  void _showFailedSnackbar(){
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          Text(
              "Não foi possível salvar as informações!!"
          ),
        ],
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _onSaveButtonPressed() async {
    FocusScope.of(context).unfocus();
    if(_contactFormKey.currentState.validate()){
      _contactFormKey.currentState.save();

      final success = await bloc.saveContact();
      if(success) {
        Navigator.of(context).pop(success);
      }
      else {
        _showFailedSnackbar();
      }
    }
  }

  String _validateName(String value) {
    if (value?.isEmpty ?? true) return "O campo nome não pode ficar vazio.";
    return null;
  }

  String _validateEmail(String value) {
    if (value?.isEmpty ?? true) return "O campo email não pode ficar vazio.";
    return null;
  }

  String _validatePhone(String value) {
    if (value?.isEmpty ?? true) return "O campo telefone não pode ficar vazio.";
    return null;
  }

  void _onSaveName(String value) => bloc.name = value;
  void _onSaveEmail(String value) => bloc.email = value;
  void _onSavePhone(String value) => bloc.phone = value;
}
