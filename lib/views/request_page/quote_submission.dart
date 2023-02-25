import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/file_buttons/deletable_file_button.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/models/request.dart';

import '../../components/buttons/filled_button.dart';
import '../../components/icons/qicon.dart';
import '../../components/input_fields/standard_input_field.dart';
import '../../controllers/attached_file_controller.dart';
import '../../models/user.dart';

class QuoteSubmissionSection extends StatefulWidget {
  final RequestModel model;
  final VoidCallback onFinish;
  final FileController fileController;
  final bool focusOnInputField;
  const QuoteSubmissionSection(
      {Key? key,
      required this.model,
      required this.onFinish,
      this.focusOnInputField = false,
      required this.fileController})
      : super(key: key);

  @override
  State<QuoteSubmissionSection> createState() => _QuoteSubmissionSectionState();
}

class _QuoteSubmissionSectionState extends State<QuoteSubmissionSection> {
  final TextEditingController quoteController = TextEditingController();
  bool sent = false;

  List<Widget> buildAttachedFiles() {
    var paths = widget.fileController.filePaths;

    List<Widget> widgets = [];
    if (paths.isNotEmpty) {
      widgets.add(
        const Text(
          'Attached files',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF28282A),
            fontSize: 18,
          ),
        ),
      );
    }
    for (var path in paths) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: DeletableAttachedFileButton(
          path: path,
          onPressed: () {
            setState(() {
              widget.fileController.removeByPath(path);
            });
          },
        ),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit a quote',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF28282A),
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextInputField(
            autoFocus: widget.focusOnInputField,
            controller: quoteController,
            hint: 'Enter details about your quote',
            maxLength: 2000,
            maxLines: null,
          ),
          ...buildAttachedFiles(),
          const SizedBox(
            height: 10,
          ),
          CustomFilledButton(
              fillColors: const [
                Color(0xFFEAEAEB),
                Color(0xFFEAEAEB),
              ],
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                await widget.fileController.pickFiles();
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      transform: Matrix4.rotationZ(0.7),
                      transformAlignment: Alignment.center,
                      child: QIcon(QIcons.addMedia)),
                  const Text(
                    'Add media',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF28282A),
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          FilledTextButton(
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                if (quoteController.text.length < 5) {
                  showError(context,
                      'Quote is too short. You need to provide more details');
                  return;
                }

                if (sent == true) {
                  showInfo(context, "Quote already sent. Please wait");

                  return;
                }
                sent = true;
                await widget.model.sendQuote(quoteController.text,
                    widget.fileController.files, userModelProvider);

                widget.onFinish();
                quoteController.clear();

                widget.fileController.clear();
              },
              message: 'Submit Quote'),
        ],
      ),
    );
  }
}
