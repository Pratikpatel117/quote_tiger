import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/views/request_page/pages/private_request_page.dart';
import 'package:quote_tiger/views/request_page/pages/public_request_page.dart';

class RequestPage extends StatefulWidget {
  final RequestModel model;
  final UserModel? buyerModel;
  final bool focusOnInputField;
  const RequestPage(
      {Key? key,
      required this.model,
      this.buyerModel,
      this.focusOnInputField = false})
      : super(key: key);

  @override
  State<RequestPage> createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    if (widget.model.creatorID == userModelProvider.id) {
      return PrivateRequestPage(model: widget.model);
    }
    return PublicRequestPage(
      model: widget.model,
      focusOnInputField: widget.focusOnInputField,
    );
  }
}
