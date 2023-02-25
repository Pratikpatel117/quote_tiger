import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:quote_tiger/components/buttons/go_back_button.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/components/tiles/attached_file/downloadable_attached_file_tile.dart';
import 'package:quote_tiger/controllers/attached_file_controller.dart';
import 'package:quote_tiger/models/chat/chat.dart';
import 'package:quote_tiger/models/chat/chat_user.dart';
import 'package:quote_tiger/models/chat/message.dart';
import 'package:quote_tiger/models/chat/messages/file_message.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/notifications/notification_manager.dart';
import 'package:quote_tiger/utils/interval_since_right_now.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';

import '../../components/tiles/message_tile.dart';
import '../../utils/push.dart';

class ChatPage extends StatefulWidget {
  final ChatUser localUser;
  final ChatUser otherUser;
  final ChatModel chatModel;

  const ChatPage({
    Key? key,
    required this.localUser,
    required this.otherUser,
    required this.chatModel,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late CachedNetworkImage otherUserImageFile;
  late CachedNetworkImage localUserImageFile;
  late StreamSubscription streamSubscription;
  List<MessageModel> documentsToShow = [];

  final FileController fileController = FileController();

  bool isAlreadyIn(DocumentSnapshot snapshot) {
    for (var document in documentsToShow) {
      if (document.id == snapshot.id) {
        return true;
      }
    }
    return false;
  }

  void onChangeData(List<DocumentChange> documentChanges) {
    for (var change in documentChanges) {
      if (change.type == DocumentChangeType.added && !isAlreadyIn(change.doc)) {
        documentsToShow.insert(0, getMessageModel(change.doc));
      }
    }
    setState(() {});
  }

  Future<void> initialQuery() async {
    var docSnaps = (await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatModel.id)
            .collection('messages')
            .orderBy('creation_date', descending: true)
            .limit(10)
            .get())
        .docs;
    List<MessageModel> messages = [];
    for (var document in docSnaps) {
      messages.add(getMessageModel(document));
    }

    documentsToShow = messages;
  }

  Future<void> requestNextBatch() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatModel.id)
        .collection('messages')
        .orderBy('creation_date', descending: true)
        .startAfterDocument(documentsToShow.last.snapshot!)
        .limit(5)
        .get();

    List<MessageModel> models = [];
    for (var doc in querySnapshot.docs) {
      models.add(getMessageModel(doc));
    }

    documentsToShow.addAll(models);
  }

  Future<void> readChat(String localUserID, String otherUserID) async {
    //delete all notifications
    var documents = (await FirebaseFirestore.instance
            .collection('notifications')
            .where('target', isEqualTo: localUserID)
            .where("type", isEqualTo: "message")
            .where("sender", isEqualTo: otherUserID)
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

  @override
  void initState() {
    readChat(widget.localUser.id, widget.otherUser.id);
    NotificationSingleton().currentChatPageID = widget.chatModel.id;
    otherUserImageFile = CachedNetworkImage(
      imageUrl: widget.otherUser.image,
      progressIndicatorBuilder: (_, e, f) {
        return const CircleAvatar();
      },
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          backgroundImage: imageProvider,
        );
      },
    );
    localUserImageFile = CachedNetworkImage(
      imageUrl: widget.localUser.image,
      progressIndicatorBuilder: (_, e, f) {
        return const CircleAvatar();
      },
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          backgroundImage: imageProvider,
        );
      },
    );

    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        requestNextBatch().then((value) {
          setState(() {});
        });
      }
    });

    initialQuery().then((value) {
      setState(() {});
    });

    streamSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatModel.id)
        .collection('messages')
        .orderBy('creation_date', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      onChangeData(event.docChanges);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
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
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GoBackButton(
                context,
                onPressed: () {
                  NotificationSingleton().currentChatPageID = null;
                  Navigator.pop(context);
                },
              ),
              InkWell(
                onTap: () {
                  push(context, ProfilePageRoute(userID: widget.otherUser.id));
                },
                child: Row(children: [
                  otherUserImageFile,
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.otherUser.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ]),
              ),
              const SizedBox(
                width: 40,
              )
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: documentsToShow.length,
                itemBuilder: (context, index) {
                  bool showDate = false;
                  MessageModel currentMessage = documentsToShow[index];

                  if (index == documentsToShow.length - 1) {
                    showDate = true;
                  } else {
                    if (currentMessage.creationDate
                            .difference(documentsToShow[index + 1].creationDate)
                            .inHours >
                        1) {
                      showDate = true;
                    }
                  }

                  return Column(
                    children: [
                      if (showDate)
                        DateTimeSeparator(
                            text: intervalSinceCurrentMoment(
                                currentMessage.creationDate)),
                      MessageWidget(
                        userImage: userModelProvider.id ==
                                documentsToShow[index].senderID
                            ? localUserImageFile
                            : otherUserImageFile,
                        message: documentsToShow[index],
                        isMe: userModelProvider.id ==
                            documentsToShow[index].senderID,
                      ),
                    ],
                  );
                },
              )),
              AttachedFilesViewer(controller: fileController),
              MessageComposer(
                onAttach: () async {
                  if (fileController.fileNames.length > 5) {
                    showAlert(context, 'You can only add up to 5 files');
                    return;
                  }
                  try {
                    await fileController.pickFiles(limit: 5);
                  } catch (e) {
                    showError(context, e.toString());
                  }
                  setState(() {});
                },
                controller: messageController,
                onSent: () async {
                  if (messageController.text.trim() == "" &&
                      fileController.files.isEmpty) {
                    messageController.clear();
                    return;
                  }

                  if (fileController.files.isNotEmpty) {
                    late String text;

                    if (messageController.text.isNotEmpty) {
                      text = messageController.text.trim();
                    } else {
                      text =
                          path.basename(fileController.files.first.path).trim();
                    }

                    setState(() {
                      messageController.clear();
                    });
                    var newFileController = FileController();
                    newFileController.files = fileController.files;
                    fileController.clear();
                    setState(() {});
                    await widget.chatModel.sendMessage(text, userModelProvider,
                        fileController: newFileController);
                    return;
                  }
                  if (messageController.text.isNotEmpty) {
                    final text = messageController.text.trim();
                    setState(() {
                      messageController.clear();
                    });
                    await widget.chatModel.sendMessage(text, userModelProvider);
                  }
                },
              ),
            ],
          ),
        ));
  }
}

class AttachedFilesViewer extends StatefulWidget {
  final FileController controller;
  const AttachedFilesViewer({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<AttachedFilesViewer> createState() => _AttachedFilesViewerState();
}

class _AttachedFilesViewerState extends State<AttachedFilesViewer> {
  Widget buildFiles() {
    List<String> imageExtensions = ['.jpg', '.jpeg', '.png'];
    var files = widget.controller.files;
    List<File> images = [];
    List<Widget> fileWidgets = [];
    for (var file in files) {
      if (imageExtensions.contains(path.extension(file.path))) {
        //image;
        images.add(file);
      } else {
        fileWidgets.add(FileTile(
          file: file,
          onPressed: () {
            push(context, FileViewer(file: file));
          },
          onRemove: () {
            widget.controller.removeByPath(file.path);
            setState(() {});
          },
        ));
      }
      //non-image;
    }
    if (fileWidgets.isEmpty && images.isEmpty) return const SizedBox();
    return Column(
      children: [
        const Divider(),
        LimitedBox(
            maxHeight: images.isEmpty ? 0 : 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, index) => const SizedBox(
                width: 30,
              ),
              itemCount: images.length,
              itemBuilder: (_, index) {
                return AttachedImageFile(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AttachedImageViewer(
                            onDelete: () {
                              widget.controller.removeFile(images[index].path);
                              images.removeAt(index);
                              setState(() {});
                              Navigator.pop(_);
                            },
                            image: images[index]));
                  },
                  image: images[index],
                );
              },
            )),
        if (images.isNotEmpty)
          const SizedBox(
            height: 10,
          ),
        ...fileWidgets,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildFiles();
  }
}

class MessageComposer extends StatelessWidget {
  final VoidCallback onSent;
  final VoidCallback onAttach;
  final TextEditingController controller;
  const MessageComposer({
    Key? key,
    required this.onSent,
    required this.controller,
    required this.onAttach,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LimitedBox(
        maxHeight: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: QIcon(
                QIcons.addMedia,
                color: Theme.of(context).primaryColor,
              ),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: onAttach,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  maxLines: null,
                  maxLength: 250,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (e) => onSent(),
                  controller: controller,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    counterText: "",
                    hintText: 'Send a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: QIcon(
                QIcons.send,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: onSent,
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimeSeparator extends StatelessWidget {
  final String text;
  const DateTimeSeparator({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: const Divider(
              color: Color(0xFFAEAEB2),
              height: 50,
            )),
      ),
      Text(
        text,
        style: const TextStyle(
            color: Color(0xFFAEAEB2),
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: const Divider(
              color: Color(0xFFAEAEB2),
              height: 50,
            )),
      ),
    ]);
  }
}

class FileTile extends StatelessWidget {
  final File file;
  final VoidCallback onPressed;
  final VoidCallback onRemove;
  const FileTile(
      {Key? key,
      required this.file,
      required this.onPressed,
      required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              path.basename(file.path),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class AttachedImageFile extends StatelessWidget {
  final VoidCallback onPressed;
  final File image;
  const AttachedImageFile(
      {Key? key, required this.onPressed, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: LimitedBox(
        maxHeight: 100,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(5, 2), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(image)),
        ),
      ),
    );
  }
}

class AttachedImageViewer extends StatefulWidget {
  final File image;
  final VoidCallback onDelete;
  const AttachedImageViewer(
      {Key? key, required this.image, required this.onDelete})
      : super(key: key);

  @override
  State<AttachedImageViewer> createState() => _AttachedImageViewerState();
}

class _AttachedImageViewerState extends State<AttachedImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: QIcon(QIcons.close),
                ),
                Text(
                  path.basename(widget.image.path),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LimitedBox(
                  maxHeight: 250,
                  child: Hero(
                      tag: 'attached-image', child: Image.file(widget.image))),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              minLeadingWidth: 1,
              leading: const Icon(
                Icons.cancel_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              onTap: widget.onDelete,
              minLeadingWidth: 1,
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: const Text(
                'Remove',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ));
  }
}
