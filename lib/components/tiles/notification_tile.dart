import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/models/chat/chat_user.dart';
import 'package:quote_tiger/models/notification.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/request.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/chat/chat_page.dart';
import 'package:quote_tiger/views/request_page/request_page.dart';
import 'package:skeletons/skeletons.dart';

import '../../services/chat/chat.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel model;
  final VoidCallback deleteNotification;

  const NotificationTile(
      {Key? key, required this.model, required this.deleteNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModelProvider = Provider.of<UserModel>(context);
    return FutureBuilder(
        future: UserService.getUserById(model.senderID, getSectors: false),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SkeletonNotificationTile();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          UserModel sender = snapshot.data as UserModel;
          return NotificationTileWidget(
            onPressed: () async {
              deleteNotification();

              switch (model.type) {
                case NotificationType.message:
                  var messageNotification =
                      model as ChatMessageNotificationModel;
                  var chatModel = await getChatById(messageNotification.chatID);

                  if (chatModel == null) {
                    showError(context,
                        "An error has occured. We couldn't find the chat");
                    return;
                  }

                  push(
                      context,
                      ChatPage(
                          localUser: ChatUser.fromUserModel(userModelProvider),
                          otherUser: ChatUser.fromUserModel(
                              snapshot.data as UserModel),
                          chatModel: chatModel),
                      chatID: chatModel.id);

                  return;
                case NotificationType.quote:
                  var quoteNotification = model as QuoteNotificationModel;
                  var requestModel = await RequestService.getRequestById(
                      quoteNotification.requestID);

                  push(context, RequestPage(model: requestModel));
                  return;
                default:
                  debugPrint('nothing');
                  return;
              }
            },
            senderUserModel: sender,
            notificationModel: model,
          );
        });
  }
}

class NotificationTileWidget extends StatefulWidget {
  final UserModel senderUserModel;
  final NotificationModel notificationModel;
  final VoidCallback onPressed;
  const NotificationTileWidget({
    Key? key,
    required this.senderUserModel,
    required this.notificationModel,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<NotificationTileWidget> createState() => _NotificationTileWidgetState();
}

class _NotificationTileWidgetState extends State<NotificationTileWidget> {
  Widget buildTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.senderUserModel.fullName + ' ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          if (widget.notificationModel.type == NotificationType.quote)
            const TextSpan(
              text: "has quoted your request",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          if (widget.notificationModel.type == NotificationType.message)
            const TextSpan(
              text: "has messaged you",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onPressed,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(
          widget.senderUserModel.image,
        ),
      ),
      title: buildTitle(),
    );
  }
}

class SkeletonNotificationTile extends StatelessWidget {
  const SkeletonNotificationTile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
        child: Column(
      children: [
        Row(
          children: [
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  shape: BoxShape.circle, width: 50, height: 50),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 1,
                    lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 10,
                        borderRadius: BorderRadius.circular(8),
                        maxLength:
                            MediaQuery.of(context).size.width * (4 / 5))),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
