import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:quote_tiger/controllers/singletons/navigation.dart';
import 'package:quote_tiger/models/request.dart';

import '../../models/user.dart';

class DynamicLinksService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      NavigationSingleton().navigatorKey.currentState?.pushNamed(
          dynamicLinkData.link.path,
          arguments: dynamicLinkData.link.queryParameters);
    }).onError((error) {
      debugPrint(error);
    });
  }

  Future<String> createDynamicLink(String targetLink,
      SocialMetaTagParameters socialMetaTagParameters) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: socialMetaTagParameters,
      uriPrefix: 'https://quotetigerapp.page.link',
      link: Uri.parse(targetLink),
      androidParameters: const AndroidParameters(
        packageName: 'com.quote.tiger',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.quote.tiger',
        minimumVersion: '0',
      ),
    );

    final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(
      parameters,
    );

    return shortLink.shortUrl.toString();
  }

  Future<String> createDynamicLinkForRequest(RequestModel model) async {
    Uri url = Uri(
        scheme: 'https',
        host: 'quotetigerapp.page.link',
        path: 'request',
        queryParameters: {'id': model.id});

    return createDynamicLink(
        url.toString(),
        SocialMetaTagParameters(
            title: model.title,
            description: model.description,
            imageUrl: Uri.parse(
              'https://i.imgur.com/atVY4ss.png',
            )));
  }

  Future<String> createDynamicLinkForApp() async {
    Uri url = Uri(
      scheme: 'https',
      host: 'quotetigerapp.page.link',
    );

    return createDynamicLink(
        url.toString(),
        SocialMetaTagParameters(
            title: "Quote Tiger",
            description:
                "Quote Tiger is an app where you have the chance to offer RFQs",
            imageUrl: Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/quotetiger-7f160.appspot.com/o/files%2Fframe_white.jpg?alt=media&token=d3c47fa1-231e-4868-95a1-5290f84ef47d',
            )));
  }

  Future<String> createDynamicLinkForUser(UserModel model) async {
    Uri url = Uri(
        scheme: 'https',
        host: 'quotetigerapp.page.link',
        path: 'user',
        queryParameters: {'id': model.id});
    return createDynamicLink(
        url.toString(),
        SocialMetaTagParameters(
          title: model.fullName,
          description:
              "${model.fullName} has invited you to join them and many other businesses on QuoteTiger-The worlds first request based marketplace app. Download now.",
          imageUrl: Uri.parse(model.image),
        ));
  }
}

extension Truncate on String {
  String truncate({required int max, String suffix = ''}) {
    return length < max
        ? this
        : '${substring(0, substring(0, max - suffix.length).lastIndexOf(" "))}$suffix';
  }
}
