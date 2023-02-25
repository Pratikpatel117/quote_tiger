import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quote_tiger/models/chat/chat.dart';

import 'chat_user.dart';

class MenuChatModel extends ChatModel {
  MenuChatModel({
    required super.user1,
    required super.user2,
    required super.creationDate,
    required super.id,
    required super.lastMessageDate,
    required super.users,
    required this.fullNameUser1,
    required this.fullNameUser2,
    required this.imageUser1,
    required this.imageUser2,
    required this.lastMessageContent,
  });

  final String lastMessageContent;
  final String fullNameUser1;
  final String fullNameUser2;
  final String imageUser1;
  final String imageUser2;
  factory MenuChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MenuChatModel(
      lastMessageContent:
          snapshot.field<String>('last_message_content') ?? "No message yet",
      lastMessageDate: snapshot['last_message_date'].toDate(),
      fullNameUser1: snapshot.field<String>("name_user1") ?? '',
      fullNameUser2: snapshot.field<String>("name_user2") ?? '',
      imageUser1: snapshot.field<String>("image_user1") ?? '',
      imageUser2: snapshot.field<String>("image_user2") ?? '',
      users: snapshot['users'].cast<String>(),
      user1: snapshot['user1'],
      user2: snapshot['user2'],
      id: snapshot.id,
      creationDate:
          DateTime.parse(snapshot['creation_date'].toDate().toString()),
    );
  }
  ChatUser getChatUserByID(String userID) {
    if (user1 == userID) {
      return ChatUser.fromUser1(this);
    }
    if (user2 == userID) {
      return ChatUser.fromUser2(this);
    }

    throw ErrorHint("Couln't find the user of id $userID");
  }
}

extension EmailValidator on DocumentSnapshot {
  T? field<T>(String fieldName) {
    try {
      return get(fieldName);
    } catch (e) {
      return null;
    }
  }
}
