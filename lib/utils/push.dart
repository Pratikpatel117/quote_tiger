import 'package:flutter/material.dart';
import 'package:quote_tiger/services/notifications/notification_manager.dart';

Future<void> push(BuildContext context, Widget page, {String? chatID}) async {
  NotificationSingleton().currentChatPageID = chatID;
  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}
