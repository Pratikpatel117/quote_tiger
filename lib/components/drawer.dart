import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/filled_icon_button.dart';
import 'package:quote_tiger/components/dialogs/quote_tiger_dialog.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/help_page.dart';
import 'package:quote_tiger/views/my_activity_page.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/views/main_tabs/favorited_page.dart';
import 'package:quote_tiger/views/popups/invite_page.dart';
import 'package:quote_tiger/views/popups/onboarding.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';

import 'icons/qicon.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15);
  Widget buildProfile(UserModel model) {
    return GestureDetector(
      onTapUp: (e) {
        push(
          context,
          ProfilePage(model: model),
        ).then((value) {
          setState(() {});
        });
      },
      child: Row(
        children: [
          // user image
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(model.image)),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: -0.7,
                ),
              ),
              Text(
                '@${model.username}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFFC6C6C8),
                  letterSpacing: -0.7,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDivider(
      {Color color = const Color(0xFFD5D5D7), double width = 1}) {
    return Divider(
      thickness: width,
      color: color,
    );
  }

  Widget buildListItem({
    required VoidCallback onPressed,
    required Widget leading,
    required String title,
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16,
    Color fontColor = Colors.black,
  }) {
    return ListTile(
      onTap: onPressed,
      contentPadding: padding,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget buildIconListTile({
    required VoidCallback onPressed,
    required QIconData iconData,
    required String title,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xFF28282A),
  }) {
    return buildListItem(
      onPressed: onPressed,
      leading: FilledIconButton(
        icon: iconData,
        passiveIconColor: color,
      ),
      title: title,
      fontColor: color,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          push(
                            context,
                            const OnBoarding(
                              fromDrawer: true,
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Image.asset('assets/logo/banner.png'),
                          height: 90,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      buildProfile(userModelProvider),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildListItem(
                  onPressed: () {
                    push(context, const MyActivityPage());
                  },
                  leading: FilledIconButton(
                    passiveFillColor: const Color(0xFFFCA205),
                    passiveIconColor: Colors.white,
                    icon: QIcons.q,
                  ),
                  fontWeight: FontWeight.w700,
                  title: 'My activity',
                ),
                buildDivider(color: const Color(0xFFFFC55F), width: 2),
                buildIconListTile(
                  onPressed: () {
                    push(context, const FavoritedPage());
                  },
                  iconData: QIcons.star,
                  title: 'Favourites',
                ),
                buildDivider(),
                buildIconListTile(
                    onPressed: () {
                      push(context, const HelpPage());
                    },
                    iconData: QIcons.help,
                    title: 'Help'),
                buildDivider(),
                buildIconListTile(
                    onPressed: () {
                      push(context, const InvitePage());
                    },
                    iconData: QIcons.invite,
                    title: 'Invite'),
                buildDivider(),
                buildIconListTile(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (ctx) => QuoteTigerDialog(
                              declineMessage: 'Cancel',
                              acceptMessage: 'Log out',
                              title: 'Are you sure?',
                              message: 'Are you sure you want to log out?',
                              onAccept: () async {
                                deleteNotificationToken(userModelProvider);
                                Navigator.pop(ctx);
                                await authProvider.signOut();
                              },
                              onDecline: () {
                                Navigator.pop(ctx);
                              },
                            ));
                  },
                  iconData: QIcons.logout,
                  title: 'Log out',
                  color: Colors.red,
                ),
                buildDivider(color: Colors.red),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                'QuoteTiger © 2022',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFFAEAEB2)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteNotificationToken(UserModel userModelProvider) async {
    var token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModelProvider.id)
        .collection('tokens')
        .doc(token)
        .delete();
  }
}
