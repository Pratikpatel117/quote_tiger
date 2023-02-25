import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quote_tiger/components/snackbar/top_snack_bar.dart';
import 'package:quote_tiger/services/notifications/notification_manager.dart';

import '../../components/notifications/message_notification.dart';
import '../../components/notifications/quote_notification.dart';
import '../../controllers/singletons/navigation.dart';
import '../../models/user.dart';
import '../user.dart';

void initializeLocalNotifications() {
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) {});
  createInAppNotificationListener();
  createNotificationOpeningListener();
}

void createNotificationOpeningListener() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    String? path = convertTypeToPath(message);
    NavigationSingleton()
        .navigatorKey
        .currentState!
        .pushNamed(path!, arguments: message.data);
  });
}

String? convertTypeToPath(RemoteMessage message) {
  var pathTranslator = {
    'quote': '/request/',
    'message': '/chat/',
  };
  final path = pathTranslator[message.data['type']];
  return path;
}

Future<void> createInAppNotificationListener() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? ios = message.notification?.apple;

    validatePlatform();

    if (notification == null) {
      throw NullThrownError();
    }

    if (android != null) {
      createInAppAndroidNotification(notification, message.data);
    }
    if (ios != null) {
      createInAppIosNotification(notification);
    }
  });
}

void validatePlatform() {
  if (kIsWeb) {
    throw PlatformException(
        code: 'wrong_platform',
        message: "Notifications don't work on your platform");
  }
}

void createInAppIosNotification(RemoteNotification notification) =>
    print("Gotta make this bro");

Future<void> createInAppAndroidNotification(
  RemoteNotification notification,
  Map<String, dynamic> data,
) async {
  switch (data['type']) {
    case 'quote':
      var context = NotificationSingleton().context;
      if (context == null) {
        return;
      }
      return showTopSnackBar(
        context,
        QuoteNotificationWidget(requestID: data['request_id']),
      );
    case 'message':
      var senderModel = await UserService.getUserById(data['sender_id']);
      var notificationSingleton = NotificationSingleton();

      var context = notificationSingleton.context;
      var currentChatId = notificationSingleton.currentChatPageID;

      if (context == null) {
        return;
      }

      if (data['chat_id'] == currentChatId) {
        return;
      }

      return showTopSnackBar(
        context,
        MessageNotificationWidget(
            senderModel: senderModel,
            chatID: data['chat_id'],
            messageContent: data['message_content']),
      );

    default:
      throw Exception("Implement this bro 3");
  }
}

Future<void> initializeFirebaseMessaging() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  validatePlatform();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> submitFCMtoken(UserModel model) async {
  var token = await FirebaseMessaging.instance.getToken();
  if (token == null) {
  } else {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(model.id)
        .collection('tokens')
        .doc(token)
        .set({
      'creation_date': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
      'token': token,
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
}
