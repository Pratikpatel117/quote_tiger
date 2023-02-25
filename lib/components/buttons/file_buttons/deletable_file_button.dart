import 'package:flutter/material.dart';

import 'package:path/path.dart' as path_handler;

import '../../icons/qicon.dart';

class DeletableAttachedFileButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String path;

  const DeletableAttachedFileButton(
      {Key? key, required this.onPressed, required this.path})
      : super(key: key);

  @override
  State<DeletableAttachedFileButton> createState() =>
      DeletableAttachedFileButtonState();
}

class DeletableAttachedFileButtonState
    extends State<DeletableAttachedFileButton> {
  String shorten(String basename) {
    var list = basename.split('.');
    late String shortedFileName;
    if (list[0].length > 11) {
      shortedFileName = list[0].substring(0, 10);
    } else {
      shortedFileName = list[0];
    }
    var shortedNameWithDots = shortedFileName + '...';

    if (shortedFileName.length < list[0].length &&
        shortedNameWithDots.length < list[0].length) {
      return list[0].substring(0, 20) + '... ' + '.' + list[1];
    }
    return basename;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: 40,
        decoration: const BoxDecoration(color: Color(0xFFFFF6E6)),
        child: Row(children: [
          QIcon(
            QIcons.close,
            color: const Color(0xFFD48700),
            size: 25,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            shorten(path_handler.basename(widget.path)),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFD48700),
              fontSize: 18,
            ),
          ),
        ]),
      ),
    );
  }
}
