import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/notification.dart';

/// the possible states of the user
enum NotifStatus {
  pending,
  read,
  nothing,
}

/// Manage:
/// 1. times_opened (how many times the app has been opened)

class NotificationsProvider extends ChangeNotifier {
  List<NotificationModel> notifications = [];
  bool initializedListener = false;
  initializeListener(String? userID) {
    if (initializedListener || userID == null) {
      print("FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK");
      return;
    }
    initializedListener = true;
    FirebaseFirestore.instance
        .collection('notifications')
        .limit(10)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        notifications.add(getNotificationFromSnapshot(doc));
      }
    });
  }
}
