import 'package:flutter/material.dart';
import 'package:quote_tiger/services/request.dart';

import '../models/request.dart';
import '../views/request_page/request_page.dart';

class RequestPageRoute extends StatefulWidget {
  final String requestID;
  const RequestPageRoute({Key? key, required this.requestID}) : super(key: key);

  @override
  State<RequestPageRoute> createState() => _RequestPageRouteState();
}

class _RequestPageRouteState extends State<RequestPageRoute> {
  late RequestModel requestModel;
  bool done = false;

  @override
  void initState() {
    RequestService;
    RequestService.getRequestById(widget.requestID).then((value) {
      setState(() {
        done = true;
        requestModel = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RequestPage(
      model: requestModel,
    );
  }
}
