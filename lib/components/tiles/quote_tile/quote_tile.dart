import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/tiles/attached_file/downloadable_attached_file_tile.dart';
import 'package:quote_tiger/models/quote.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:quote_tiger/utils/push.dart';

import '../../../services/chat/chat.dart';
import '../../../utils/flags.dart';
import '../../../views/profile/profile_page.dart';
import '../../icons/qicon.dart';

class QuoteTile extends StatefulWidget {
  final QuoteModel model;
  final bool isFromMyQuotes;
  const QuoteTile({
    Key? key,
    required this.model,
    required this.isFromMyQuotes,
  }) : super(key: key);

  @override
  State<QuoteTile> createState() => _QuoteTileState();
}

class _QuoteTileState extends State<QuoteTile> {
  bool canOpenChat = true;
  UserModel? profileUser;

  bool isMyQuote(UserModel localUser) {
    if (localUser.id == widget.model.creatorID) {
      return true;
    }
    return false;
  }

  Future<Widget> buildProfile(UserModel localUser) async {
    profileUser = await getUser(localUser);

    return InkWell(
      onTap: () {
        push(context, ProfilePage(model: profileUser!));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user image
                CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(profileUser!.image)),
                const SizedBox(
                  width: 18,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileUser!.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.7,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '@${profileUser!.username}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xFFC6C6C8),
                            letterSpacing: 0.02,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC6C6C8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(
                          '${getFlagFromCountryName(profileUser!.location)}  ${profileUser!.location}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color(0xFFC6C6C8),
                            letterSpacing: 0.02,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<UserModel> getUser(UserModel localUser) async {
    if (widget.isFromMyQuotes) {
      if (profileUser == null) {
        return await UserService.getUserById(widget.model.requestCreatorID,
            getSectors: false);
      }
    }
    if (isMyQuote(localUser)) {
      return localUser;
    } else {
      return await UserService.getUserById(widget.model.creatorID,
          getSectors: false);
    }
  }

  List<Widget> buildAttachedFiles() {
    List<Widget> widgets = [];
    for (var url in widget.model.fileURLs) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: DownloadableAttachedFileTile(
          fileURL: url,
        ),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: buildProfile(userModelProvider),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return snapshot.data as Widget;
                },
              ),
              Text(widget.model.content),
            ],
          ),
          ...buildAttachedFiles(),
          const SizedBox(
            height: 10,
          ),
          if (!isMyQuote(userModelProvider))
            CustomFilledButton(
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                if (!canOpenChat) {
                  return;
                }
                canOpenChat = false;
                if (profileUser == null) {
                  canOpenChat = true;
                  return;
                }
                if (profileUser!.id == userModelProvider.id) return;

                await ChatService()
                    .createOrOpenChat(context, profileUser!, userModelProvider);

                canOpenChat = true;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QIcon(
                    QIcons.message,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text(
                    'Contact',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
