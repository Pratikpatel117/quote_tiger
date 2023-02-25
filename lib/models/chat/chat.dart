import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/controllers/attached_file_controller.dart';
import 'package:quote_tiger/models/chat/messages/file_message.dart';

import '../user.dart';
import 'message.dart';

class ChatModel {
  final String user1;
  final String user2;
  final DateTime creationDate;
  final String id;
  final DateTime lastMessageDate;
  List<String> users;

  ChatModel({
    required this.user1,
    required this.user2,
    required this.creationDate,
    required this.id,
    required this.lastMessageDate,
    required this.users,
  });

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    //print('snapshotDataChatModel: ${snapshot.data()}');
    return ChatModel(
      lastMessageDate: snapshot['last_message_date'].toDate(),
      users: snapshot['users'].cast<String>(),
      user1: snapshot['user1'],
      user2: snapshot['user2'],
      id: snapshot.id,
      creationDate:
          DateTime.parse(snapshot['creation_date'].toDate().toString()),
    );
  }

  /// send message chat
  Future<MessageModel> sendMessage(String text, UserModel sender,
      {FileController? fileController}) async {
    var urls = await fileController?.uploadAll('chats/$id');
    var names = fileController?.fileNames;
    var extensions = fileController?.extensions;
    List<Map<String, dynamic>> fileMaps = [];
    if (urls != null) {
      for (var i = 0; i < urls.length; i++) {
        fileMaps.add({
          'url': urls[i],
          'basename': names![i],
          'type': ['.png', '.jpg', '.jpeg'].contains(extensions![i])
              ? FileMessageType.image.index
              : FileMessageType.file.index
        });
      }
    }
    var reference = await FirebaseFirestore.instance
        .collection('chats')
        .doc(id)
        .collection('messages')
        .add({
      'type': urls == null || urls.isEmpty
          ? MessageType.text.index
          : MessageType.file.index,
      'files': urls == null ? [] : fileMaps,
      'chat': id,
      'target': _getOtherUser(sender.id),
      'sender': sender.id,
      'is_read': false,
      'content': text,
      'creation_date': FieldValue.serverTimestamp(),
    });

    if (user1 == sender.id) {
      await updateUserOneInDocument(text, sender);
    }
    if (user2 == sender.id) {
      await updateUserTwoInDocument(text, sender);
    }

    return MessageModel(
      type: MessageType.text,
      chatID: id,
      target: _getOtherUser(sender.id),
      content: text,
      id: reference.id,
      senderID: sender.id,
      creationDate: creationDate,
    );
  }

  Future<void> updateUserTwoInDocument(String text, UserModel sender) async {
    await FirebaseFirestore.instance.collection('chats').doc(id).update({
      'last_message_date': FieldValue.serverTimestamp(),
      'last_message_content': text,
      'image_user2': sender.image,
      'name_user2': sender.fullName
    });
  }

  Future<void> updateUserOneInDocument(String text, UserModel sender) async {
    await FirebaseFirestore.instance.collection('chats').doc(id).update({
      'last_message_date': FieldValue.serverTimestamp(),
      'last_message_content': text,
      'image_user1': sender.image,
      'name_user1': sender.fullName
    });
  }

  String _getOtherUser(String localUser) {
    if (user1 == localUser) {
      return user2;
    }
    return user1;
  }
}
