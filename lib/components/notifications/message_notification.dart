import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/chat/chat_page.dart';

import '../../models/chat/chat_user.dart';
import '../../services/chat/chat.dart';

class MessageNotificationWidget extends StatefulWidget {
  final UserModel senderModel;
  final String messageContent;
  final String chatID;
  const MessageNotificationWidget({
    Key? key,
    required this.senderModel,
    required this.messageContent,
    required this.chatID,
  }) : super(key: key);

  @override
  State<MessageNotificationWidget> createState() =>
      _MessageNotificationWidgetState();
}

class _MessageNotificationWidgetState extends State<MessageNotificationWidget> {
  bool canTap = true;
  late CachedNetworkImage senderImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    return Material(
      child: InkWell(
        onTap: () async {
          if (canTap == false) return;
          canTap = false;

          var chatModel = await getChatById(widget.chatID);
          push(
              context,
              ChatPage(
                  localUser: ChatUser.fromUserModel(userModelProvider),
                  otherUser: ChatUser.fromUserModel(widget.senderModel),
                  chatModel: chatModel!),
              chatID: chatModel.id);
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 90.0,
            maxHeight: 100,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: kDefaultBorderRadius,
            boxShadow: kDefaultBoxShadow,
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.senderModel.image,
                  progressIndicatorBuilder: (_, e, f) {
                    return const CircleAvatar(
                      maxRadius: 33,
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      maxRadius: 33,
                      backgroundImage: imageProvider,
                    );
                  },
                ),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.senderModel.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black,
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
                          widget.messageContent,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
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
        ),
      ),
    );
  }
}

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0.0, 8.0),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];
