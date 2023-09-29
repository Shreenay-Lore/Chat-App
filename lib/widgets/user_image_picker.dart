import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;    //to get preview of taken picture..

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,   //This will get a small file Size...
      maxWidth: 150,
    );

    if(pickedImage == null){
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);  //stored in temporary location..
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          maxRadius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),

        TextButton.icon(
          onPressed: _pickImage, 
          icon: const Icon(Icons.image,), 
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}