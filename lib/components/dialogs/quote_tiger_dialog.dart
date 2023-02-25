import 'package:flutter/material.dart';

import 'package:quote_tiger/components/icons/qicon.dart';

import '../buttons/empty_button.dart';
import '../buttons/filled_button.dart';

class QuoteTigerDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String acceptMessage;
  final String declineMessage;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const QuoteTigerDialog(
      {Key? key,
      required this.title,
      this.message,
      required this.acceptMessage,
      required this.declineMessage,
      required this.onAccept,
      required this.onDecline})
      : super(key: key);

  @override
  State<QuoteTigerDialog> createState() => _QuoteTigerDialogState();
}

class _QuoteTigerDialogState extends State<QuoteTigerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 19),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: QIcon(QIcons.close))
              ],
            ),
            if (widget.message != null)
              const SizedBox(
                height: 20,
              ),
            if (widget.message != null)
              Text(
                widget.message!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EmptyTextButton(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 48,
                  onPressed: widget.onDecline,
                  child: Text(
                    widget.declineMessage,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                FilledTextButton(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 48,
                  fontSize: 17,
                  onPressed: widget.onAccept,
                  message: widget.acceptMessage,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
