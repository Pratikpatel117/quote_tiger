import 'package:flutter/material.dart';

import '../../models/quote.dart';
import '../tiles/attached_file/downloadable_attached_file_tile.dart';

class SentQuoteWidget extends StatelessWidget {
  final QuoteModel model;
  const SentQuoteWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My quote',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(model.content,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            )),
        LimitedBox(
            maxHeight: model.fileURLs.isNotEmpty ? 200 : 0,
            maxWidth: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: model.fileURLs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DownloadableAttachedFileTile(
                    fileURL: model.fileURLs[index]),
              ),
            )),
      ],
    );
  }
}
