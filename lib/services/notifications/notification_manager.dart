import 'package:flutter/material.dart';

class NotificationSingleton {
  static final NotificationSingleton _singleton =
      NotificationSingleton._internal();
  BuildContext? context;
  String? currentChatPageID;

  void init(BuildContext context) {
    this.context = context;
  }

  factory NotificationSingleton() {
    return _singleton;
  }

  NotificationSingleton._internal();
}

class Placeholder {
  static final Placeholder _singleton = Placeholder._internal();

  factory Placeholder() {
    return _singleton;
  }

  Placeholder._internal();
}
