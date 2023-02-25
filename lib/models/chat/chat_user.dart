import 'package:quote_tiger/models/chat/menu_chat.dart';

import '../user.dart';

class ChatUser {
  final String id;
  final String image;
  final String name;

  ChatUser({
    required this.id,
    required this.image,
    required this.name,
  });

  factory ChatUser.fromUser1(MenuChatModel chatModel) {
    return ChatUser(
        id: chatModel.user1,
        image: chatModel.imageUser1,
        name: chatModel.fullNameUser1);
  }
  factory ChatUser.fromUser2(MenuChatModel chatModel) {
    return ChatUser(
        id: chatModel.user2,
        image: chatModel.imageUser2,
        name: chatModel.fullNameUser2);
  }

  factory ChatUser.fromUserModel(UserModel userModel) {
    return ChatUser(
      id: userModel.id,
      image: userModel.image,
      name: userModel.fullName,
    );
  }
}
