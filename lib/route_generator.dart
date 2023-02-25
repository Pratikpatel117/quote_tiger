import 'package:flutter/material.dart';
import 'package:quote_tiger/main.dart';
import 'package:quote_tiger/routes/chat_route.dart';
import 'package:quote_tiger/routes/request_route.dart';
import 'package:quote_tiger/services/notifications/notification_manager.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    var path = settings.name!;
    if (settings.name![settings.name!.length - 1] != '/') {
      path = path + '/';
    }
    if (path == '/user/') {
      path = '/profile/';
    }
    switch (path) {
      case '/request/':
        var args = settings.arguments as Map<String, dynamic>;
        var id = args['request_id'];
        id ??= args['id'];
        return MaterialPageRoute(builder: (context) {
          return RequestPageRoute(requestID: id);
        });

      case '/profile/':
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (ctx) {
          return ProfilePageRoute(userID: args['id']);
        });

      case '/chat/':
        var args = settings.arguments as Map<String, dynamic>;
        NotificationSingleton().currentChatPageID = args['chat_id'];

        return MaterialPageRoute(builder: (ctx) {
          return ChatPageRoute(
            chatId: args['chat_id'],
            senderId: args['sender_id'],
            targetId: args['target_id'],
          );
        });

      default:
        return MaterialPageRoute(builder: (_) => const AppPagesController());
    }
  }
}
