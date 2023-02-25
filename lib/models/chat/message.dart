import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  file,
}

class MessageModel {
  final String content;
  final String senderID;
  final String target;
  final DateTime creationDate;
  final String chatID;
  final String id;
  final DocumentSnapshot? snapshot;
  final MessageType type;

  MessageModel(
      {required this.id,
      required this.content,
      required this.senderID,
      required this.creationDate,
      required this.target,
      required this.chatID,
      required this.type,
      this.snapshot});

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    //print('creation date: ${snapshot['creation_date']}');
    DateTime? time;

    if (snapshot['creation_date'] != null) {
      time = snapshot['creation_date'].toDate();
    }

    return MessageModel(
        type: MessageType.values[snapshot['type']],
        target: snapshot['target'],
        snapshot: snapshot,
        id: snapshot.id,
        content: snapshot['content'],
        senderID: snapshot['sender'],
        chatID: snapshot['chat'],
        creationDate: time ?? DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'senderID': senderID,
      'creationDate': creationDate,
      'target': target,
      'chatID': chatID,
    };
  }
}
