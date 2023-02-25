import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum NotificationType { general, account, message, request, quote, development }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String senderID;
  final String targetID;
  final DateTime creationDate;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.senderID,
    required this.targetID,
    required this.creationDate,
    required this.isRead,
  });
  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    return NotificationModel(
      isRead: false,
      id: snapshot.id,
      type: notificationTypeFromString(snapshot['type']),
      senderID: snapshot['sender'],
      targetID: snapshot['target'],
      creationDate: snapshot['creation_date'].toDate(),
    );
  }
}

class QuoteNotificationModel extends NotificationModel {
  final String quoteID;
  final String requestID;
  QuoteNotificationModel({
    required this.quoteID,
    required this.requestID,
    required String id,
    required NotificationType type,
    required String senderID,
    required String targetID,
    required DateTime creationDate,
  }) : super(
    isRead: false,
          id: id,
          type: type,
          senderID: senderID,
          targetID: targetID,
          creationDate: creationDate,
        );
  factory QuoteNotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    return QuoteNotificationModel(
      id: snapshot.id,
      type: notificationTypeFromString(snapshot['type']),
      senderID: snapshot['sender'],
      targetID: snapshot['target'],
      creationDate: snapshot['creation_date'].toDate(),
      quoteID: snapshot['quote_id'],
      requestID: snapshot['request_id'],
    );
  }
}

class ChatMessageNotificationModel extends NotificationModel {
  final String chatID;
  final String messageID;
  final String content;
  ChatMessageNotificationModel({
    required this.chatID,
    required this.messageID,
    required this.content,
    required String id,
    required NotificationType type,
    required String senderID,
    required String targetID,
    required DateTime creationDate,
  }) : super(
    isRead: false,
            id: id,
            type: type,
            senderID: senderID,
            targetID: targetID,
            creationDate: creationDate);
  factory ChatMessageNotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      debugPrint('snap doesn\'t exist');
    }
    return ChatMessageNotificationModel(
      content: snapshot['content'],
      chatID: snapshot['chat'],
      id: snapshot.id,
      type: notificationTypeFromString(snapshot['type']),
      senderID: snapshot['sender'],
      targetID: snapshot['target'],
      creationDate: snapshot['creation_date'].toDate(),
      messageID: snapshot['message_id'],
    );
  }
}

NotificationModel getNotificationFromSnapshot(DocumentSnapshot snapshot) {
  var notificationModel = NotificationModel.fromSnapshot(snapshot);
  switch (notificationModel.type) {
    case NotificationType.quote:
      return QuoteNotificationModel.fromSnapshot(snapshot);
    case NotificationType.message:
      return ChatMessageNotificationModel.fromSnapshot(snapshot);
    default:
      return notificationModel;
  }
}

NotificationType notificationTypeFromString(String string) {
  switch (string) {
    case 'message':
      return NotificationType.message;
    case 'quote':
      return NotificationType.quote;
    default:
      return NotificationType.general;
  }
}
