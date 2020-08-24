import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/product_bloc.dart';
import 'package:gerenciamento_loja_online/helpers/format_helper.dart';
import 'package:gerenciamento_loja_online/ui/product_page/images_widget.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey();
  final ProductBloc _bloc;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;

  @override
  void initState() {
    final state = _bloc.state;
    _titleController = TextEditingController(text: state.title);
    _descriptionController = TextEditingController(text: state.description);
    _priceController = TextEditingController(text: FormatHelper.currencyFormat(state.price));
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
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: BlocBuilder<ProductBloc,ProductBlocState>(
          cubit: _bloc,
          buildWhen: (oldState, newState) => oldState.mode != newState.mode,
          builder: (context, state){
            return Text(
              state.mode == ProductPageMode.editProd ? 'Editar Produto' : 'Criar Produto',
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
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
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
              builder: (context, state){
                return ImagesWidgets(
                  context: context,
                  initialValue: state.imagesList,
                  onSaved: (images){},
                  validator: (images){},
                );
              },
            ),
            TextFormField(
              controller: _titleController,
              style: fieldStyle,
              decoration: _buildDecoration('Titulo'),
              onSaved: (newValue) {},
            ),
            TextFormField(
              controller: _descriptionController,
              style: fieldStyle,
              decoration: _buildDecoration('Descrição'),
              maxLines: 6,
              onSaved: (newValue) {},
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
            )
          ],
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
}
