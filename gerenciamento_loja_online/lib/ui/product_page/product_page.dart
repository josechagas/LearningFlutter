import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/product_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/bloc_event.dart';
import 'package:gerenciamento_loja_online/helpers/format_helper.dart';
import 'package:gerenciamento_loja_online/ui/product_page/images_widget.dart';
import 'package:gerenciamento_loja_online/ui/product_page/product_validators.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  ProductPage({@required this.categoryId, this.product, Key key})
      : super(key: key);
  final String categoryId;
  final DocumentSnapshot product;

  @override
  _ProductPageState createState() => _ProductPageState(categoryId, product);
}

class _ProductPageState extends State<ProductPage> {
  _ProductPageState(String categoryId, DocumentSnapshot product)
      : _bloc = ProductBloc(ProductBlocState(
          categoryId: categoryId,
          product: product,
        ));

  final ProductBloc _bloc;
  final ProductValidator productValidator = ProductValidator();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  final GlobalKey<FormFieldState> _priceController;

  @override
  void initState() {
    final state = _bloc.state;
    _titleController = TextEditingController(text: state.title);
    _descriptionController = TextEditingController(text: state.description);
    _priceController =
        TextEditingController(text: FormatHelper.currencyFormat(state.price));
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: BlocBuilder<ProductBloc, ProductBlocState>(
          cubit: _bloc,
          buildWhen: (oldState, newState) => oldState.mode != newState.mode,
          builder: (context, state) {
            return Text(
              state.mode == ProductPageMode.editProd
                  ? 'Editar Produto'
                  : 'Criar Produto',
            );
          },
        ),
        actions: [
          BlocBuilder<ProductBloc, ProductBlocState>(
            cubit: _bloc,
            buildWhen: (oldState, newState) => oldState.mode != newState.mode,
            builder: (context, state) {
              return Visibility(
                visible: state.mode == ProductPageMode.editProd,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {},
                ),
              );
            },
          ),
          BlocBuilder<ProductBloc, ProductBlocState>(
            cubit: _bloc,
            buildWhen: (oldState, newState) =>
                oldState.saveStatus != newState.saveStatus,
            builder: (BuildContext context, ProductBlocState state) {
              return state.saveStatus == ProductSaveStatus.saving
                  ? Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.save,
                      ),
                      onPressed: saveChanges,
                    );
            },
          ),
        ],
      ),
      body: BlocListener<ProductBloc, ProductBlocState>(
        cubit: _bloc,
        listenWhen: (oldState, newState) =>
            newState.saveStatus != ProductSaveStatus.none,
        listener: onBlocStateUpdateListener,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                'Imagens',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              BlocBuilder<ProductBloc, ProductBlocState>(
                cubit: _bloc,
                builder: (context, state) {
                  return ImagesWidgets(
                    context: context,
                    initialValue: state.imagesList,
                    onSaved: (images) {},
                    validator: validateImages,
                  );
                },
              ),
              TextFormField(
                controller: _titleController,
                style: fieldStyle,
                decoration: _buildDecoration('Titulo'),
                onSaved: (newValue) {},
                validator: validateTitle,
              ),
              TextFormField(
                controller: _descriptionController,
                style: fieldStyle,
                decoration: _buildDecoration('Descrição'),
                maxLines: 6,
                onSaved: (newValue) {},
                validator: validateDescription,
              ),
              TextFormField(
                controller: _priceController,
                style: fieldStyle,
                inputFormatters: [
                  TextInputFormatter.withFunction(
                      FormatHelper.currencyTFFormatter)
                ],
                decoration: _buildDecoration('Preço'),
                keyboardType: TextInputType.numberWithOptions(),
                onSaved: (newValue) {},
                validator: validatePrice,
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
    );
  }

  void onBlocStateUpdateListener(BuildContext context, ProductBlocState state) {
    Widget content;
    SnackBarAction action;
    switch (state.saveStatus) {
      case ProductSaveStatus.saving:
        content = Text(
          state.mode == ProductPageMode.editProd
              ? 'Salvando Alterações ...'
              : 'Salvando Produto ...',
          style: TextStyle(
            color: Colors.white,
          ),
        );
        break;
      case ProductSaveStatus.success:
        content = Text(
          state.mode == ProductPageMode.editProd
              ? 'Alterações salvas com sucesso!'
              : 'Produto salvo com sucesso!',
          style: TextStyle(
            color: Colors.white,
          ),
        );
        break;
      case ProductSaveStatus.failed:
        content = Text(
          state.mode == ProductPageMode.editProd
              ? 'Falha em salvar Alterações!'
              : 'Falha em salvar novo Produto!',
          style: TextStyle(
            color: Colors.white,
          ),
        );
        break;
      default:
        break;
    }

    if(content != null) {
      _scaffoldKey.currentState.removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: content,
        action: action,
        duration: Duration(
          seconds: 2,
        ),
      ));
    }
  }

  String validateTitle(String title) {
    if (productValidator.validateTitle(title)) {
      return null;
    }
    return 'Preencha o titulo do produto';
  }

  String validateDescription(String description) {
    if (productValidator.validateDescription(description)) {
      return null;
    }
    return 'Preencha a descrição do produto';
  }

  String validatePrice(String price) {
    if (productValidator.validatePrice(price)) {
      return null;
    }
    return 'Preço inválido.';
  }

  String validateImages(List images) {
    if (productValidator.validateImages(images)) {
      return null;
    }
    return 'Adicione ao menos uma imagem ao produto.';
  }

  void saveChanges() {
    if (_formKey.currentState.validate()) {
      final dataMap = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': NumberFormat.simpleCurrency()
            .parse(_priceController.text), //centavos
      };
      _bloc.add(BlocEvent(ProductBlocEvent.save, data: dataMap));
    } else {}
  }
}
