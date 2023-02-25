import 'package:flutter/material.dart';

import 'package:quote_tiger/components/snackbar/top_snack_bar.dart';

enum DialogType {
  error,
  success,
  info,
  alert,
}

class MessageDialog extends StatefulWidget {
  final String title;
  final String content;
  final DialogType type;

  const MessageDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.type,
  }) : super(key: key);

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  late Color primaryColor;

  @override
  void initState() {
    primaryColor = getColorBasedOnType(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: kDefaultBoxShadow,
        borderRadius: kDefaultBorderRadius,
      ),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildIcon(widget.type),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: primaryColor,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textScaleFactor: 1,
                  ),
                  LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width / 1.7,
                    child: Text(
                      widget.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      ),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textScaleFactor: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorBasedOnType(DialogType type) {
    switch (type) {
      case DialogType.alert:
        return Colors.orange;
      case DialogType.error:
        return Colors.red;
      case DialogType.info:
        return Colors.grey;
      case DialogType.success:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget buildIcon(DialogType type) {
    var size = 50.0;
    switch (type) {
      case DialogType.alert:
        return Icon(
          Icons.error_outline,
          color: primaryColor,
          size: size,
        );
      case DialogType.success:
        return Icon(
          Icons.done,
          color: primaryColor,
          size: size,
        );
      case DialogType.info:
        return Icon(
          Icons.error_outline,
          color: primaryColor,
          size: size,
        );
      case DialogType.error:
        return Icon(
          Icons.error_outline,
          color: primaryColor,
          size: size,
        );
      default:
        return Icon(
          Icons.error_outline,
          color: primaryColor,
          size: size,
        );
    }
  }
}

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

void _showMessageDialog(
    BuildContext context, String title, String content, DialogType type) {
  showTopSnackBar(
      context, MessageDialog(title: title, content: content, type: type));
}

void showError(BuildContext context, String content) {
  _showMessageDialog(context, "Error", content, DialogType.error);
}

void showAlert(BuildContext context, String content) {
  _showMessageDialog(context, "Alert", content, DialogType.alert);
}

void showSucces(BuildContext context, String content) {
  _showMessageDialog(context, "Success", content, DialogType.success);
}

void showInfo(BuildContext context, String content) {
  _showMessageDialog(context, "Info", content, DialogType.info);
}
