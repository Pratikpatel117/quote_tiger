import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/filled_icon_button.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/provider/globals_provider.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/main_tabs/favorited_page.dart';
import 'package:quote_tiger/views/main_tabs/chat_menu.dart';
import 'package:quote_tiger/views/main_tabs/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/views/main_tabs/feed.dart';
import 'package:quote_tiger/views/search/request_search/request_search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/creators/request_creator.dart';
import '../components/drawer.dart';
import '../components/icons/qicon.dart';
import '../services/notifications/notification_manager.dart';
import '../services/notifications/notifications.dart';

class NavigationWrapper extends StatefulWidget {
  final int? timesAppOpened;
  final UserModel localUserModel;
  const NavigationWrapper(
      {Key? key, required this.timesAppOpened, required this.localUserModel})
      : super(key: key);

  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final Color selectedItemColor = const Color(0xFFFCA205);
  final Color unselectedItemColor = const Color(0xFFD5D5D7);
  bool initializedNotificationSingleTon = false;
  bool sentToken = false;

  List<Widget> _pages = [];

  void sendFtm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sent = prefs.getBool('sent_ftm');
    if (sent == null) {
      return;
    }
    if (!sent) {
      submitFCMtoken(widget.localUserModel);
      await prefs.setBool('sent_ftm', true);
    }
  }

  @override
  void initState() {
    _pages = [
      const FeedPage(),
      const FavoritedPage(
        showAppBar: false,
      ),
      NotificationsPage(
        localUserModel: widget.localUserModel,
      ),
      ChatMenu(
        drawerKey: _key,
      ),
    ];
    sendFtm();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalsProvider globalsProvider = Provider.of<GlobalsProvider>(context);
    if (!initializedNotificationSingleTon) {
      NotificationSingleton().init(context);
    }
    final userModelProvider = Provider.of<UserModel>(context);

    return Scaffold(
      key: _key,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFFFCA205),
                    Color(0xFFFFC55F),
                  ],
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showModalBottomSheet<RequestModel>(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                      initialChildSize: 0.8,
                      minChildSize: 0.8,
                      builder: (context, scrollController) {
                        return SafeArea(
                            child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0)),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: RequestCreator(),
                                )));
                      });
                },
              ).then((value) {
                setState(() {});
              });
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 60,
            margin: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          globalsProvider.setCurrentPage(0);
                        });
                      },
                      icon: QIcon(
                        QIcons.home,
                        size: 25,
                        color: globalsProvider.currentPage == 0
                            ? selectedItemColor
                            : unselectedItemColor,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          globalsProvider.setCurrentPage(1);
                        });
                      },
                      color: globalsProvider.currentPage == 1
                          ? selectedItemColor
                          : unselectedItemColor,
                      icon: QIcon(
                        QIcons.star,
                        size: 25,
                        color: globalsProvider.currentPage == 1
                            ? selectedItemColor
                            : unselectedItemColor,
                      )),
                  const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          globalsProvider.setCurrentPage(2);
                        });
                      },
                      icon: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('notifications')
                              .where("target", isEqualTo: userModelProvider.id)
                              .where("type", isEqualTo: "quote")
                              .orderBy('creation_date', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snap) {
                            if (!snap.hasData) {
                              return QIcon(
                                QIcons.notification,
                                size: 25,
                                color: globalsProvider.currentPage == 2
                                    ? selectedItemColor
                                    : unselectedItemColor,
                              );
                            }
                            var isnotEmpty = snap.data?.docs.isNotEmpty;
                            print(snap.data?.docs);
                            return Stack(
                              children: [
                                QIcon(
                                  QIcons.notification,
                                  size: 25,
                                  color: globalsProvider.currentPage == 2
                                      ? selectedItemColor
                                      : unselectedItemColor,
                                ),
                                if ((isnotEmpty ?? false) &&
                                    globalsProvider.currentPage != 2)
                                  Positioned(
                                    right: 3,
                                    top: 2,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                          border:
                                              Border.all(color: Colors.white)),
                                    ),
                                  ),
                              ],
                            );
                          })),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          globalsProvider.setCurrentPage(3);
                        });
                      },
                      icon: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('notifications')
                              .where("target", isEqualTo: userModelProvider.id)
                              .where("type", isEqualTo: 'message')
                              .orderBy('creation_date', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snap) {
                            if (!snap.hasData) {
                              return QIcon(
                                QIcons.message,
                                size: 25,
                                color: globalsProvider.currentPage == 3
                                    ? selectedItemColor
                                    : unselectedItemColor,
                              );
                            }
                            var isnotEmpty = snap.data?.docs.isNotEmpty;
                            print(snap.data?.docs);
                            return Stack(children: [
                              QIcon(
                                QIcons.message,
                                size: 25,
                                color: globalsProvider.currentPage == 3
                                    ? selectedItemColor
                                    : unselectedItemColor,
                              ),
                              if ((isnotEmpty ?? false) &&
                                  globalsProvider.currentPage != 3)
                                Positioned(
                                  right: 3,
                                  top: 2,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                        border:
                                            Border.all(color: Colors.white)),
                                  ),
                                )
                            ]);
                          }))
                ]),
          )),
      drawer: const UserDrawer(),
      appBar: globalsProvider.currentPage != 3
          ? AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFFFCA205),
                      Color(0xFFFFC55F),
                    ],
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OldFilledIconButton(
                    icon: Icons.menu,
                    size: 40,
                    onPressed: () {
                      _key.currentState!.openDrawer();
                    },
                  ),
                  const Trademark(),
                  FilledIconButton(
                    icon: QIcons.search,
                    size: 40,
                    onPressed: () {
                      push(
                          context,
                          const RequestSearchPage(
                            initialQuery: '',
                            focusOnSearch: true,
                          ));
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _pages[globalsProvider.currentPage],
    );
  }
}

class PopUp extends StatefulWidget {
  const PopUp({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Request a quote',
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: -0.9,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }
}
