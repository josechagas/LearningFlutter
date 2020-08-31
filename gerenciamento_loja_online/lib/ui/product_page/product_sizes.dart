import 'package:flutter/material.dart';

class ProductSizes extends FormField<List<String>> {
  ProductSizes({
    BuildContext context,
    List<String> initialValue,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
  }) : super(
          builder: (state) {
            return Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              runSpacing: 0,
              spacing: 10,
              children: state.value
                  .map<Widget>((size) => _buildSizeButton(context, size, state)).toList()
                    ..insert(
                      0,
                        _buildAddSizeButton(context, state)
                    ),
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
        ),
        onLongPress: ()=> _onSizeTapped(size, state),
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

  static void _onAddSizeTapped(BuildContext context, FormFieldState<List<String>> state) {

  }
}
