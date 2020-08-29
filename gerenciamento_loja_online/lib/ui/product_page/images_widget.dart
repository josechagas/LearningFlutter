
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gerenciamento_loja_online/ui/product_page/image_source_sheet.dart';

class ImagesWidgets extends FormField<List> {
  ImagesWidgets({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List<dynamic> initialValue,
    bool autoValidate = false,
}) : super(
    onSaved: onSaved,
    initialValue: List<dynamic>.from(initialValue),
    validator: validator,
    autovalidate: autoValidate,
    builder: (state){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 124,
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: state.value.map<Widget>((item) {
                return Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    child: item is String ? Image.network(item, fit: BoxFit.cover) : Image.file(item, fit: BoxFit.cover,),
                    onLongPress: (){
                      state.didChange(state.value..remove(item));
                    },
                  ),
                );
              }).toList()..add(GestureDetector(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.white10,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white.withAlpha(50),
                  ),
                ),
                onTap: (){
                  showModalBottomSheet(context: context, builder: (BuildContext context){
                    return ImageSourceSheet(onImageSelected: (fileImage){
                      state.didChange(state.value..add(fileImage));
                      Navigator.of(context).pop();
                    },);
                  });
                },
              )),
            ),
          ),
          state.hasError ? Text(
            state.errorText,
            style: Theme.of(context).textTheme.caption.copyWith(
              color: Theme.of(context).errorColor,
            ),
          ) : SizedBox.shrink(),
        ],
      );
    }
  );
}