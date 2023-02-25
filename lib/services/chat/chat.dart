import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_tiger/components/dialogs/chat_creation_dialog.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/models/chat/menu_chat.dart';

import '../../models/chat/chat.dart';
import '../../models/chat/chat_user.dart';
import '../../models/user.dart';
import '../../utils/push.dart';
import '../../views/chat/chat_page.dart';

class ChatService {
  bool _canStartChatProcess = true;

  Future<List<MenuChatModel>> getChatsFromUserID(String userID) async {
    var snapshots = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: userID)
        .orderBy('last_message_date', descending: true)
        .limit(15)
        .get();

    List<MenuChatModel> models = [];

    for (var snapshot in snapshots.docs) {
      models.add(MenuChatModel.fromSnapshot(snapshot));
    }

    return models;
  }

  Future<void> createOrOpenChat(
      BuildContext context, UserModel otherUser, UserModel localUser) async {
    if (_isTheSameUser(localUser, otherUser)) {
      showAlert(context, "Can't message yourself.");
      return;
    }

    if (_canStartChatProcess == false) {
      return;
    }
    _canStartChatProcess = false;

    var chat = await _getChat(localUser, otherUser, context);

    _canStartChatProcess = true;
    if (chat != null) {
      push(
          context,
          ChatPage(
              localUser: ChatUser.fromUserModel(localUser),
              otherUser: ChatUser.fromUserModel(otherUser),
              chatModel: chat),
          chatID: chat.id);
    }
  }

  bool _isTheSameUser(UserModel localUser, UserModel otherUser) {
    if (localUser.id == otherUser.id) return true;
    return false;
  }

  Future<ChatModel?> _createChat(BuildContext context, UserModel localUser,
      UserModel requestCreatorModel) async {
    final chatModel = await showDialog<ChatModel>(
        context: context,
        builder: (_) {
          return ChatCreationDialog(
            otherUser: requestCreatorModel,
          );
        });
    return chatModel;
  }

  Future<ChatModel?> _getChat(
      UserModel localUser, UserModel otherUser, BuildContext context) async {
    var chat = await retrieveChat(localUser.id, otherUser.id);
    chat ??= await _createChat(context, localUser, otherUser);
    return chat;
  }
}

Future<ChatModel?> retrieveChat(String user1, String user2) async {
  var snap1 = await FirebaseFirestore.instance
      .collection('chats')
      .where('user1', isEqualTo: user1)
      .where('user2', isEqualTo: user2)
      .limit(1)
      .get();

  if (snap1.docs.isNotEmpty) {
    return ChatModel.fromSnapshot(snap1.docs.first);
  }
  var snap2 = await FirebaseFirestore.instance
      .collection('chats')
      .where('user1', isEqualTo: user2)
      .where('user2', isEqualTo: user1)
      .limit(1)
      .get();
  if (snap2.docs.isNotEmpty) {
    return ChatModel.fromSnapshot(snap2.docs.first);
  }

  return null;
}

Future<ChatModel> createChat(UserModel localUser, UserModel targetUser) async {
  //Creates another chat even if there already is one;
  if (localUser.id == targetUser.id) {
    throw ErrorHint(
        'The local user and the target user can\'t be the same one when creating a chat');
  }
  final possibleChat = await retrieveChat(localUser.id, targetUser.id);
  if (possibleChat != null) return possibleChat;

  var reference = await FirebaseFirestore.instance.collection('chats').add({
    'last_message_date': FieldValue.serverTimestamp(),
    'last_message_content': 'No Messages Yet',
    "name_user1": localUser.fullName,
    "name_user2": targetUser.fullName,
    "image_user1": localUser.image,
    "image_user2": targetUser.image,
    'users': [localUser.id, targetUser.id],
    'creation_date': FieldValue.serverTimestamp(),
    'user1': localUser.id,
    'user2': targetUser.id,
  });

  return ChatModel(
      lastMessageDate: DateTime.now(),
      users: [localUser.id, targetUser.id],
      user1: localUser.id,
      user2: targetUser.id,
      creationDate: DateTime.now(),
      id: reference.id);
}

Future<ChatModel?> getChatById(String id) async {
  var snapshot =
      await FirebaseFirestore.instance.collection('chats').doc(id).get();
  if (!snapshot.exists) {
    return null;
  }
  return ChatModel.fromSnapshot(snapshot);
}
