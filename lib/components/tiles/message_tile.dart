import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/components/tiles/attached_file/downloadable_attached_file_tile.dart';
import 'package:quote_tiger/models/chat/messages/file_message.dart';
import 'package:quote_tiger/utils/push.dart';
import '../../models/chat/message.dart';

TextStyle localMessageTextStyle = const TextStyle(
    fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white);
TextStyle receivedMessageTextStyle = const TextStyle(
    fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black);

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.userImage})
      : super(key: key);

  final MessageModel message;
  final CachedNetworkImage userImage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe) userImage,
        if (!isMe)
          const SizedBox(
            width: 10,
          ),
        buildTextMessage(context),
      ],
    );
  }

  List<Widget> buildFiles(BuildContext context, List<FileModel> fileModels) {
    List<Widget> images = [];
    for (var fileModel in fileModels) {
      images.add(buildFileMessage(context, fileModel));
    }
    return images;
  }

  Widget buildFileMessage(BuildContext context, FileModel fileModel) {
    if (fileModel.type == FileMessageType.image) {
      return buildImageMessage(context, fileModel);
    }
    return buildAnyFileMessage(context, fileModel);
  }

  Padding buildImageMessage(BuildContext context, FileModel fileModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () async {
            showDialog(
                context: context,
                builder: (_) => _ImageViewer(model: fileModel));
          },
          child: CachedNetworkImage(
            progressIndicatorBuilder: (_, i, __) {
              return Text(fileModel.basename);
            },
            fit: BoxFit.fitWidth,
            imageUrl: fileModel.url,
          ),
        ),
      ),
    );
  }

  Widget buildAnyFileMessage(BuildContext context, FileModel fileModel) {
    return InkWell(
      onTap: () async {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        //Here you'll specify the file it should be saved as
        File file = File('${appDocDir.path}/${fileModel.basename}');

        await FirebaseStorage.instance
            .refFromURL(fileModel.url)
            .writeToFile(file);
        showInfo(context, "File downloaded to storage");

        push(context, FileViewer(file: file));
      },
      child: Text(
        fileModel.basename,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isMe ? Colors.grey[100] : Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Container buildTextMessage(BuildContext context) {
    return Container(
      margin: isMe
          ? const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : const EdgeInsets.only(bottom: 8.0, right: 80),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * (isMe ? 0.75 : 0.6),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFFCA205) : const Color(0xFFEAEAEB),
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(5),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: isMe ? localMessageTextStyle : receivedMessageTextStyle,
          ),
          if (message.type == MessageType.file)
            ...buildFiles(context, (message as FileMessageModel).files)
        ],
      ),
    );
  }
}

class _ImageViewer extends StatefulWidget {
  final FileModel model;
  const _ImageViewer({Key? key, required this.model}) : super(key: key);

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Image view',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (_, i, __) {
                      return Text(widget.model.url);
                    },
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.model.url,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
