import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  ImageSourceSheet({Key key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
              child: Text(
                'Camera',
              ),
              onPressed: () async {
                PickedFile imageFile = await ImagePicker().getImage(source: ImageSource.camera,maxHeight: 500, maxWidth: 500);
                imageSelected(context, imageFile);
              },
            ),
            FlatButton(
              child: Text(
                'Galeria',
              ),
              onPressed: () async {
                PickedFile imageFile = await ImagePicker().getImage(source: ImageSource.gallery,maxHeight: 500, maxWidth: 500);
                imageSelected(context,imageFile);
              },
            ),
          ],
        );
      },
      onClosing: (){},
    );
  }

  void imageSelected(BuildContext context, PickedFile image) {
    if(image != null){
      //File croppedImage = //await ImageCropper.cropImage(sourcePath: image.path, aspectRatio: CropAspectRatio(ratioX: 1,ratioY: 1));
      Navigator.of(context).pop(File(image.path));
    }
  }
}
