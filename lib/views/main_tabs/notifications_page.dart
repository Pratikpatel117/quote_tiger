import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/errors/error_message.dart';
import 'package:quote_tiger/components/tiles/notification_tile.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/controllers/pagination/pagination_controller.dart';
import 'package:quote_tiger/models/notification.dart';
import 'package:quote_tiger/models/user.dart';

import 'package:flutter/material.dart';
import 'package:quote_tiger/provider/auth_provider.dart';

class NotificationsPage extends StatefulWidget {
  final UserModel localUserModel;
  final bool isRoute;
  const NotificationsPage(
      {Key? key,
      required this.localUserModel,

      /// widget is opened from the navbar = true
      /// else = false
      this.isRoute = false})
      : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController controller = TextEditingController();
  late PaginationController<NotificationModel> paginationController;

  @override
  void initState() {
    paginationController = PaginationController(
        query: FirebaseFirestore.instance
            .collection('notifications')
            .where('target', isEqualTo: widget.localUserModel.id)
            .orderBy('creation_date', descending: true),
        documentToModel: (snapshot) => getNotificationFromSnapshot(snapshot));
    paginationController.firstBatch().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: widget.isRoute
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
                  GoBackButton(context),
                  const Trademark(),
                  const SizedBox(
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            )
          : null,
      body: NestedScrollView(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            if (paginationController.documentModels.isEmpty) {
              return const Center(
                  child: ErrorMessage(message: "No new notifications"));
            }
            return RefreshIndicator(
              onRefresh: () async {
                paginationController.refresh();
                await paginationController.firstBatch();
                setState(() {});
              },
              child: ListView.separated(
                  separatorBuilder: (ctx, i) {
                    return const Divider();
                  },
                  itemCount: paginationController.documentModels.length,
                  itemBuilder: (_, index) {
                    return NotificationTile(
                        deleteNotification: () {
                          final id =
                              paginationController.documentModels[index].id;
                          FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(id)
                              .delete()
                              .then((value) {
                            setState(() {
                              paginationController.documentModels
                                  .removeAt(index);
                            });
                          });
                        },
                        model: paginationController.documentModels[index]);
                  }),
            );
          }),
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              letterSpacing: -0.02,
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                readAll(authProvider.model!.id);
                              },
                              child: const Text("Clear all")),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ];
        },
      ),
    );
  }

  Future<void> readAll(String localUserID) async {
    //delete all notifications
    var documents = (await FirebaseFirestore.instance
            .collection('notifications')
            .where('target', isEqualTo: localUserID)
            .get())
        .docs;
    final batch = FirebaseFirestore.instance.batch();
    for (var document in documents) {
      batch.delete(FirebaseFirestore.instance
          .collection('notifications')
          .doc(document.id));
    }
    await batch.commit();
  }
}
