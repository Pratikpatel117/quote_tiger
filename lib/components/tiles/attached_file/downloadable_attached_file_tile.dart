import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/errors/error_message.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';

import '../../../services/storage/storage.dart';

class DownloadableAttachedFileTile extends StatefulWidget {
  final String fileURL;
  const DownloadableAttachedFileTile({Key? key, required this.fileURL})
      : super(key: key);

  @override
  State<DownloadableAttachedFileTile> createState() =>
      DownloadableAttachedFileTileState();
}

class DownloadableAttachedFileTileState
    extends State<DownloadableAttachedFileTile> {
  StorageService storageService = StorageService();
  bool loading = false;
  double progress = 0;

  String shorten(String basename) {
    var list = basename.split('.');
    var shortedFileName = list[0].substring(0, 10);
    var shortedNameWithDots = shortedFileName + '...';

    if (shortedFileName.length < list[0].length &&
        shortedNameWithDots.length < list[0].length) {
      return list[0].substring(0, 20) + '... ' + '.' + list[1];
    }
    return basename;
  }

  bool isImage() {
    var fileName = storageService.getFileName(widget.fileURL);
    var fileExtension = "." + fileName.split('.').last;
    if (['.jpg', '.jpeg', '.png'].contains(fileExtension)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            storageService.downloadFile(widget.fileURL).then((value) {
              showInfo(context, "Download complete");
              setState(() {
                loading = false;
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => FileViewer(file: value)));
            });
            setState(() {
              loading = true;
            });
          },
          child: Container(
            height: isImage() ? 80 : 40,
            decoration: const BoxDecoration(color: Color(0xFFFFF6E6)),
            child: Row(children: [
              const SizedBox(
                width: 5,
              ),
              if (!isImage())
                const Icon(
                  Icons.play_arrow,
                  color: Color(0xFFD48700),
                )
              else
                SizedBox(
                    height: 70,
                    child: ClipRRect(
                      child: Image.network(widget.fileURL),
                    )),
              const SizedBox(
                width: 5,
              ),
              Text(
                shorten(storageService.getFileName(widget.fileURL)),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD48700),
                  fontSize: 18,
                ),
              ),
            ]),
          ),
        ),
        if (loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class FileViewer extends StatelessWidget {
  final File file;
  const FileViewer({Key? key, required this.file}) : super(key: key);

  Widget buildViewer() {
    switch (path.extension(file.path)) {
      case ".jpg":
        return buildImage(file);
      case ".jpeg":
        return buildImage(file);
      case ".png":
        return buildImage(file);
      case ".pdf":
        return const Text("PDF VIEWER");
      case ".txt":
        return FutureBuilder(
            future: file.readAsString(),
            builder: (_, snap) {
              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }
              return Text(snap.data as String);
            });

      default:
        return Column(
          children: [
            ErrorMessage(
                message:
                    "Unfortunately, we cannot open ${path.extension(file.path)} files"),
            FilledTextButton(
                onPressed: () {
                  OpenFile.open(file.path);
                },
                message: 'Use another app')
          ],
        );
    }
  }

  Widget buildImage(File file) {
    return Image.file(file);
  }

  @override
  Widget build(BuildContext context) {
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
            GoBackButton(context),
            const Trademark(),
            const SizedBox(
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      body: Center(child: SingleChildScrollView(child: buildViewer())),
    );
  }
}
