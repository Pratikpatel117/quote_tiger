import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quote_tiger/utils/push.dart';

import '../../routes/request_route.dart';

class QuoteNotificationWidget extends StatefulWidget {
  final String requestID;
  const QuoteNotificationWidget({
    Key? key,
    required this.requestID,
  }) : super(key: key);

  @override
  State<QuoteNotificationWidget> createState() =>
      _QuoteNotificationWidgetState();
}

class _QuoteNotificationWidgetState extends State<QuoteNotificationWidget> {
  bool canTap = true;
  late CachedNetworkImage senderImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () async {
          if (canTap == false) return;
          canTap = false;
          push(context, RequestPageRoute(requestID: widget.requestID));
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 90.0,
            maxHeight: 100,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: kDefaultBorderRadius,
            boxShadow: kDefaultBoxShadow,
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You have received a new quote',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textScaleFactor: 1,
                      ),
                      LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width / 1.7,
                        child: const Text(
                          "Tap to see the quote you received!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textScaleFactor: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0.0, 8.0),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];
