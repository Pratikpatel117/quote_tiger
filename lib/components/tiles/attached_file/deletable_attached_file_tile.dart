import 'package:flutter/material.dart';

import 'package:path/path.dart' as path_handler;

import '../../icons/qicon.dart';

class DeletableAttachedFileTile extends StatefulWidget {
  final VoidCallback onPressed;
  final String path;

  const DeletableAttachedFileTile(
      {Key? key, required this.onPressed, required this.path})
      : super(key: key);

  @override
  State<DeletableAttachedFileTile> createState() =>
      DeletableAttachedFileTileState();
}

class DeletableAttachedFileTileState extends State<DeletableAttachedFileTile> {
  String shorten(String basename) {
    var list = basename.split('.');
    return list[0].substring(0, 5) + '.' + list[1];
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
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            shorten(
              path_handler.basename(widget.path),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFD48700),
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      ),
    );
  }
}
