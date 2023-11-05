import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ImagePickerService {
  final BuildContext context;
  final Reference fbRef;

  ImagePickerService({required this.context, required this.fbRef});

  final picker = ImagePicker();
  bool isUpload = false;

  Future<String?> pickImage() async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return _buildDialogContent(isUpload, setState);
            },
          ),
          actions: _buildDialogActions(isUpload),
        );
      },
    );
  }

  Widget _buildDialogContent(bool isUpload, StateSetter setState) {
    if (isUpload) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
            source: ImageSource.camera,
            title: 'Camera',
            icon: Icons.camera,
            setState: setState),
        _buildListTile(
            source: ImageSource.gallery,
            title: 'Gallery',
            icon: Icons.image,
            setState: setState),
      ],
    );
  }

  ListTile _buildListTile(
      {required ImageSource source,
      required String title,
      required IconData icon,
      required StateSetter setState}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _handleImageSelection(source: source, setState: setState),
    );
  }

  List<Widget> _buildDialogActions(bool isUpload) {
    return !isUpload
        ? [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ]
        : [];
  }

  Future<void> _handleImageSelection(
      {required ImageSource source, required StateSetter setState}) async {
    setState(() => isUpload = true);
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final url = await uploadImage(image: File(image.path));
      setState(() => isUpload = false);
      if (url != null) {
        Navigator.pop(context, url);
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() => isUpload = false);
    }
  }

  Future<String?> uploadImage({required File image}) async {
    final fileExtension = p.extension(image.path);
    final ref =
        fbRef.child('/${DateTime.now().toIso8601String()}$fileExtension');
    final uploadTask = ref.putFile(image);

    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
