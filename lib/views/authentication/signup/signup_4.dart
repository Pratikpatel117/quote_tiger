import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/services/storage/image.dart';
import 'package:quote_tiger/utils/globals.dart';

class SignUpPage4 extends StatefulWidget {
  const SignUpPage4({Key? key}) : super(key: key);

  @override
  State<SignUpPage4> createState() => _SignUpPage4State();
}

class _SignUpPage4State extends State<SignUpPage4> {
  File? image;
  ImageService imageService = ImageService();
  Future<void> getNewImage() async {
    File? imageFile = await imageService.imagePickerDialog(context);
    if (imageFile == null) {
      return;
    }

    setState(() {
      image = imageFile;
    });
  }

  Future<void> uploadImage(AuthProvider authProvider) async {
    var imageURL = await imageService.uploadImage(
        image!, 'users/${authProvider.model!.id}');
    authProvider.updateUser(image: imageURL);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Trademark(),
              ),
              const Text(
                "Add your profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: -0.02,
                ),
              ),

              /// credit: https://stackoverflow.com/questions/64897427/how-to-make-an-image-icon-with-a-button-to-change-the-image-like-google
              /// thanks a lot @rasha for the amazing widget
              EditableImage(
                radius: 90,
                onPressed: () {
                  getNewImage();
                },
                image: image == null
                    ? NetworkImage(defaultUserImageUrl)
                    : Image.file(image!).image,
              ),

              Column(
                children: [
                  FilledTextButton(
                      width: MediaQuery.of(context).size.width,
                      onPressed: () {
                        if (image == null) {
                          showAlert(context, 'You need to pick an image first');
                          return;
                        }
                        uploadImage(authProvider);
                        Navigator.pop(context);
                      },
                      message: 'Upload'),
                  const SizedBox(
                    height: 12,
                  ),
                  SubtitleButton(
                    text: 'Skip for now',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubtitleButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  const SubtitleButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.width,
      this.height})
      : super(key: key);

  @override
  State<SubtitleButton> createState() => _SubtitleButtonState();
}

class _SubtitleButtonState extends State<SubtitleButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ));
  }
}

class EditableImage extends StatelessWidget {
  const EditableImage(
      {Key? key,
      required this.onPressed,
      required this.image,
      required this.radius})
      : super(key: key);
  final VoidCallback onPressed;
  final double radius;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundImage: image,
          ),
        ),
        Positioned(
          bottom: 1,
          right: 9,
          child: Container(
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
                color: Colors.orange,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 4),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 3,
                  ),
                ]),
          ),
        ),
        InkWell(
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.transparent,
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }
}
