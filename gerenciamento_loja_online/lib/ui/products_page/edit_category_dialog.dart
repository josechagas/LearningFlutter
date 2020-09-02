import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciamento_loja_online/blocs/category_bloc.dart';

class EditCategoryDialog extends StatefulWidget {
  EditCategoryDialog({@required this.category, Key key}) : super(key: key);

  final DocumentSnapshot category;

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  _EditCategoryDialogState({@required DocumentSnapshot category})
      : _bloc = CategoryBloc(CategoryBlocState(category: category)),
        super();

  final CategoryBloc _bloc;

  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: _bloc.state.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: GestureDetector(
              child: BlocBuilder<CategoryBloc, CategoryBlocState>(
                cubit: _bloc,
                builder: (context, state) {
                  Widget child;
                  if (state.iconUrl != null) {
                    child = Image.network(
                      state.iconUrl,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    );
                  } else if (state.iconFile != null) {
                    child = Image.file(
                      state.iconFile,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    );
                  } else {
                    child = Icon(
                      Icons.image,
                      color: Colors.white,
                    );
                  }
                  return Container(
                    child: child,
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
            title: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Categoria',
              ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              BlocBuilder<CategoryBloc, CategoryBlocState>(
                  cubit: _bloc,
                  buildWhen: (oldState, newState) =>
                      oldState.mode != newState.mode,
                  builder: (context, state) {
                    return FlatButton(
                      child: Text(
                        'Excluir',
                      ),
                      textColor: Colors.red,
                      onPressed:
                          state.mode == CategoryBlocMode.edit ? () {} : null,
                    );
                  }),
              FlatButton(
                child: Text(
                  'Salvar',
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
