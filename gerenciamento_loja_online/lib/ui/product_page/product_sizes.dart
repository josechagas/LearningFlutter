import 'package:flutter/material.dart';
import 'package:gerenciamento_loja_online/ui/product_page/add_size_dialog.dart';

class ProductSizes extends FormField<List<String>> {
  ProductSizes({
    Key key,
    BuildContext context,
    List<String> initialValue,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
  }) : super(
          key: key,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  runSpacing: 0,
                  spacing: 10,
                  children: state.value
                      .map<Widget>(
                          (size) => _buildSizeButton(context, size, state))
                      .toList()
                        ..insert(0, _buildAddSizeButton(context, state)),
                ),
                SizedBox(
                  height: 10,
                ),
                state.hasError
                    ? Text(state.errorText,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: Theme.of(context).errorColor,
                            ))
                    : SizedBox.shrink(),
              ],
            );
          },
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
        );

  static Widget _buildSizeButton(
    BuildContext context,
    String size,
    FormFieldState<List<String>> state,
  ) {
    return SizedBox(
      width: 60,
      child: MaterialButton(
        textColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
                style: BorderStyle.solid)),
        child: Text(
          size,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {},
        onLongPress: () => _onSizeTapped(size, state),
      ),
    );
  }

  static Widget _buildAddSizeButton(
    BuildContext context,
    FormFieldState<List<String>> state,
  ) {
    return SizedBox(
      width: 60,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _onAddSizeTapped(context, state),
      ),
    );
  }

  static void _onSizeTapped(String size, FormFieldState<List<String>> state) {
    state.didChange(state.value..remove(size));
  }

  static void _onAddSizeTapped(
      BuildContext context, FormFieldState<List<String>> state) async {
    String size = await showDialog(
        context: context,
        builder: (context) {
          return AddSizeDialog();
        });
    if (size != null) {
      state.didChange(state.value..add(size));
    }
  }
}
