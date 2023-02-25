import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/errors/error_message.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/models/chat/chat.dart';
import 'package:quote_tiger/models/chat/chat_user.dart';
import 'package:quote_tiger/models/chat/message.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/chat/chat.dart';
import 'package:quote_tiger/utils/interval_since_right_now.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/chat/chat_page.dart';

import '../../components/buttons/filled_icon_button.dart';
import '../../components/drawer.dart';
import '../../components/icons/qicon.dart';
import '../../models/chat/menu_chat.dart';
import '../search/user_search/user_search_page.dart';

class ChatMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  const ChatMenu({Key? key, required this.drawerKey}) : super(key: key);

  @override
  State<ChatMenu> createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  ChatService chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
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
                widget.drawerKey.currentState!.openDrawer();
              },
            ),
            const Trademark(),
            FilledIconButton(
              icon: QIcons.search,
              size: 40,
              onPressed: () {
                push(
                    context,
                    const UserSearchPage(
                      initialQuery: "",
                      focusOnSearch: true,
                    ));
              },
            ),
          ],
        ),
      ),
      drawer: const UserDrawer(),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        letterSpacing: -0.02,
                      ),
                    ),
                  ),
                ]),
              ),
            ];
          },
          body: buildMyContacts(userModelProvider),
        ),
      ),
    );
  }

  FutureBuilder<List<ChatModel>> buildMyContacts(UserModel userModelProvider) {
    return FutureBuilder(
      future: chatService.getChatsFromUserID(userModelProvider.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MenuChatModel> models = snapshot.data as List<MenuChatModel>;
          if (models.isEmpty) {
            return const ErrorMessage(
              message:
                  "No messages at the moment.  Lets change that! Share your QuoteTiger profile with your social & business network to get your contacts onboard!",
            );
          }

          return ListView.separated(
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: models.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChatTile(
                      localUserID: userModelProvider.id,
                      chatModel: models[index]),
                );
              });
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ChatTile extends StatefulWidget {
  const ChatTile({
    Key? key,
    required this.chatModel,
    required this.localUserID,
    this.onPressed,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String localUserID;
  final MenuChatModel chatModel;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late ChatUser localUser;
  late ChatUser otherUser;
  @override
  void initState() {
    if (widget.localUserID == widget.chatModel.user1) {
      localUser = ChatUser.fromUser1(widget.chatModel);
      otherUser = ChatUser.fromUser2(widget.chatModel);
    } else {
      localUser = ChatUser.fromUser2(widget.chatModel);
      otherUser = ChatUser.fromUser1(widget.chatModel);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            otherUser.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            intervalSinceCurrentMoment(widget.chatModel.creationDate),
            style: const TextStyle(
              color: Color(0xFFAEAEB2),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(otherUser.image),
      ),
      isThreeLine: true,
      subtitle: Text(
        widget.chatModel.lastMessageContent,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: widget.onPressed ??
          () async {
            push(
                context,
                ChatPage(
                    localUser: localUser,
                    otherUser: otherUser,
                    chatModel: widget.chatModel),
                chatID: widget.chatModel.id);
          },
    );
  }
}

String getCreationDate(MessageModel? model) {
  if (model == null) return '';

  return intervalSinceCurrentMoment(model.creationDate);
}
