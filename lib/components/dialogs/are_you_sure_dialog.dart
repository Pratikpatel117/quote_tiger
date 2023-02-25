import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/empty_button.dart';

import '../buttons/filled_button.dart';

class AreYouSureDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final String acceptMessage;
  final VoidCallback onDecline;
  final String declineMessage;
  final String title;

  const AreYouSureDialog(
      {Key? key,
      required this.onAccept,
      required this.onDecline,
      this.acceptMessage = 'Yes',
      this.declineMessage = 'Cancel',
      this.title = 'Are you sure?'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 12),
      titlePadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      actions: [
        EmptyTextButton(
          height: 48,
          width: MediaQuery.of(context).size.width / 2.7,
          onPressed: onDecline,
          child: Text(
            declineMessage,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        FilledTextButton(
          height: 48,
          width: MediaQuery.of(context).size.width / 2.7,
          onPressed: onAccept,
          message: acceptMessage,
        ),
      ],
    );
  }
}
