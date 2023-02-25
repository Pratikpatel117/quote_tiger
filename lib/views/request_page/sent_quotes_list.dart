import 'package:flutter/material.dart';
import 'package:quote_tiger/components/errors/error_message.dart';
import 'package:quote_tiger/components/tiles/quote_tile/quote_tile.dart';

import '../../models/request.dart';
import '../../controllers/pagination/pagination_controller.dart';

class SentQuotesListWidget extends StatefulWidget {
  final RequestModel model;
  final ScrollController controller;
  final PaginationController paginationService;
  const SentQuotesListWidget(
      {Key? key,
      required this.model,
      required this.controller,
      required this.paginationService})
      : super(key: key);

  @override
  State<SentQuotesListWidget> createState() => _SentQuotesListWidgetState();
}

class _SentQuotesListWidgetState extends State<SentQuotesListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.paginationService.getState == PaginationState.empty) {
      return const ErrorMessage(
        message:
            "You haven’t received any quotes yet, you can share the request on your social and business networks like WhatsApp and LinkedIn to get your contacts sending quotes.",
      );
    }
    if (widget.paginationService.documentModels.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: widget.paginationService.documentModels.length + 1,
        itemBuilder: ((context, index) {
          if (widget.paginationService.documentModels.length == index) {
            if (widget.paginationService.getState == PaginationState.done) {
              return const ListTile(
                title: Center(child: Text('No more quotes')),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }

          //if (paginationService.done) {
          //return estTile(model: paginationService.currentItems[index]);
          return QuoteTile(
            isFromMyQuotes: false,
            model: widget.paginationService.documentModels[index],
          );
        }),
      ),
    );
  }
}
