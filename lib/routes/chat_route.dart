import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat/chat.dart';
import '../models/chat/chat_user.dart';
import '../models/user.dart';
import '../services/chat/chat.dart';
import '../services/user.dart';
import '../views/chat/chat_page.dart';

class ChatPageRoute extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String targetId;
  const ChatPageRoute({
    Key? key,
    required this.chatId,
    required this.senderId,
    required this.targetId,
  }) : super(key: key);

  @override
  State<ChatPageRoute> createState() => _ChatPageRouteState();
}

class _ChatPageRouteState extends State<ChatPageRoute> {
  ChatModel? chatModel;
  UserModel? senderModel;

  Future<void> getChatModel() async {
    chatModel = await getChatById(widget.chatId);
    senderModel = await UserService.getUserById(widget.senderId);
    setState(() {});
  }

  @override
  void initState() {
    getChatModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);

    if (chatModel == null) {
      return const Scaffold(
        body: CircularProgressIndicator(),
      );
    }

    return ChatPage(
        localUser: ChatUser.fromUserModel(userModelProvider),
        otherUser: ChatUser.fromUserModel(senderModel!),
        chatModel: chatModel!);
  }
}
