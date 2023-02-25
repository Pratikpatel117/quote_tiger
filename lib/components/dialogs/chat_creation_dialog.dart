import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/services/chat/chat.dart';

import '../../models/user.dart';
import '../../utils/flags.dart';
import '../buttons/empty_button.dart';
import '../buttons/filled_button.dart';
import '../input_fields/standard_input_field.dart';
import '../notifications/info_dialog.dart';

class ChatCreationDialog extends StatefulWidget {
  final UserModel otherUser;

  const ChatCreationDialog({
    Key? key,
    required this.otherUser,
  }) : super(key: key);

  @override
  State<ChatCreationDialog> createState() => _ChatCreationDialogState();
}

class _ChatCreationDialogState extends State<ChatCreationDialog> {
  final TextEditingController controller = TextEditingController();

  bool isSent = false;
  Widget buildProfile() {
    return Row(
      children: [
        // user image
        Center(
          child: CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(widget.otherUser.image)),
        ),
        const SizedBox(
          width: 18,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherUser.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  '@${widget.otherUser.username}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFFAEAEB2),
                    letterSpacing: 0.02,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC6C6C8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Text(
                  '${getFlagFromCountryName(widget.otherUser.location)}  ${widget.otherUser.location}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFFAEAEB2),
                    letterSpacing: 0.02,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    return Dialog(
      insetPadding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildProfile(),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              TextInputField(
                onChanged: (e) {
                  if (isSent == true) {
                    isSent = false;
                    setState(() {});
                  }
                },
                controller: controller,
                hint: 'Enter your message',
                maxLines: 8,
                validate: (string) {
                  if (!isSent) {
                    return null;
                  }
                  if (string == "") {
                    return "Message cannot be empty";
                  }
                  if (string.length < 5) {
                    return "Message is too short";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EmptyTextButton(
                      height: 48,
                      width: MediaQuery.of(context).size.width / 2.7,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor))),
                  FilledTextButton(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 2.7,
                    onPressed: () async {
                      if (controller.text.trim() == "") {
                        showError(context, "Your message can't be empty");
                        setState(() {});
                        return;
                      }
                      if (isSent) {
                        return;
                      }
                      isSent = true;

                      var chat =
                          await createChat(userModelProvider, widget.otherUser);

                      await chat.sendMessage(
                          controller.text.trim(), userModelProvider);
                      Navigator.of(context).pop(chat);
                      showInfo(context, "Message sent");
                    },
                    message: "Send",
                    fontSize: 17,
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
