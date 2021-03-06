import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future getImage() async {
  ImagePicker imagePicker = ImagePicker();
  PickedFile pickedFile;
  pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);
  return File(pickedFile.path);
}
