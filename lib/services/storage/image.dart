import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/services/storage/storage.dart';

class ImageService {
  final picker = ImagePicker();
  final StorageService storageService = StorageService();

  /// retrieve image from camera or gallery
  Future<File?> getImage(ImageSource source, {int imageQuality = 10}) async {
    final _pickedFile = await picker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
    if (_pickedFile == null) {
      return null;
    }
    return File(_pickedFile.path);
  }

  /// crop an image using an image cropper package
  Future<File?> cropImage(
    File? image, {
    int maxWidth = 1080,
    int maxHeight = 1080,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.square
    ],
  }) async {
    if (image != null) {
      File? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: const [CropAspectRatioPreset.square],
      );
      return croppedImage;
    }
    return null;
  }

  /// the dialog where you pick the source
  Future<File?> imagePickerDialog(BuildContext context,
      {bool cameraOnly = false}) async {
    File? image;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('What are you using'),
            ],
          )),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (!cameraOnly)
                  TextButton(
                    onPressed: () async {
                      image = await getImage(ImageSource.gallery);
                      image = await cropImage(image);

                      Navigator.pop(
                        context,
                      );
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.image),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                TextButton(
                  onPressed: () async {
                    image = await getImage(ImageSource.camera);
                    image = await cropImage(image);

                    Navigator.pop(
                      context,
                    );
                  },
                  child: Column(
                    children: [
                      QIcon(
                        QIcons.photo,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Text('Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return image;
  }

  /// uploads image to storage and returns downloadURL
  Future<String?> uploadImage(File image, String parent) async {
    return await storageService.uploadFile(image, parentPath: parent);
  }
}
