import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/file_buttons/deletable_file_button.dart';
import 'package:quote_tiger/components/country_picker.dart';
import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/services/firebase/dynamic_link_service.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/request_page/request_page.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/attached_file_controller.dart';
import '../../models/sector/sector.dart';
import '../../models/user.dart';
import '../../services/storage/storage.dart';
import '../../services/utils_service.dart';
import '../buttons/empty_button.dart';
import '../buttons/filled_button.dart';
import '../input_fields/standard_input_field.dart';
import '../input_fields/tiger/tiger_dropdown_field.dart';

class RequestCreator extends StatefulWidget {
  const RequestCreator({
    Key? key,
  }) : super(key: key);

  @override
  State<RequestCreator> createState() => _RequestCreatorState();
}

class _RequestCreatorState extends State<RequestCreator> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sectorController =
      TextEditingController(text: 'Select Sector');
  final FileController fileController = FileController();
  StorageService storageService = StorageService();
  final TextEditingController countryController =
      TextEditingController(text: 'Country');
  bool created = false;

  List<Widget> getAttachedFiles() {
    var paths = fileController.filePaths;
    List<Widget> widgets = [];
    for (var path in paths) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: DeletableAttachedFileButton(
          path: path,
          onPressed: () {
            setState(() {
              fileController.removeByPath(path);
            });
          },
        ),
      ));
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);

    if (countryController.text == '' || countryController.text == 'Country') {
      countryController.text = userModelProvider.location;
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create Request',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: QIcon(QIcons.close))
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          TextInputField(controller: titleController, hint: 'Request Title'),
          const SizedBox(
            height: 12,
          ),
          TextInputField(
              maxLines: 5,
              controller: descriptionController,
              hint: 'Request Description'),
          const SizedBox(
            height: 12,
          ),
          FutureBuilder(
              future: DiverseServices.getSectors(limit: 10),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var models = snap.data as List<SectorModel>;
                List<String> names = [];
                for (var model in models) {
                  names.add(model.name);
                }
                names = <String>{...names}.toList();
                names.insert(0, 'Select Sector');

                return QuoteTigerDropdownButton(
                    choices: names, controller: sectorController);
              }),
          const SizedBox(
            height: 10,
          ),
          CountryPicker(controller: countryController),
          const SizedBox(
            height: 10,
          ),
          ...getAttachedFiles(),
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
                if (sectorController.text == 'Select Sector') {
                  showError(
                      context, "You need to pick a sector for your request");
                }
                await fileController.pickFiles();
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QIcon(QIcons.addMedia),
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
                var error = validateInput();
                if (error != null) {
                  showError(context, error);
                  return;
                }

                if (created == true) {
                  return;
                }
                created = true;

                var requestModel = await userModelProvider.createRequest(
                  titleController.text,
                  descriptionController.text,
                  sectorController.text,
                  countryController.text,
                  fileController,
                );
                Navigator.pop(context);
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => PostRequestCreationAlert(
                          model: requestModel,
                        ));

                titleController.clear();
                descriptionController.clear();
                fileController.clear();
                countryController.clear();
              },
              message: 'Submit Request'),
        ],
      ),
    );
  }

  String? validateInput() {
    if (titleController.text.isEmpty) {
      return "You need to provide a title";
    }
    if (descriptionController.text.isEmpty) {
      return "You need to provide a description";
    }
    if (sectorController.text.isEmpty ||
        sectorController.text == 'Select Sector') {
      return 'You need to pick a sector';
    }

    if (countryController.text.toLowerCase() == 'country') {
      return 'You need to choose a country';
    }
    return null;
  }
}

class PostRequestCreationAlert extends StatefulWidget {
  final RequestModel model;
  const PostRequestCreationAlert({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<PostRequestCreationAlert> createState() =>
      _PostRequestCreationAlertState();
}

class _PostRequestCreationAlertState extends State<PostRequestCreationAlert> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: QIcon(QIcons.close))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Request posted! Share the request with your network to start receiving quotes.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EmptyTextButton(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 48,
                  onPressed: () {
                    push(context, RequestPage(model: widget.model));
                  },
                  child: Text(
                    'View Request',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                FilledTextButton(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 48,
                  fontSize: 17,
                  onPressed: () async {
                    var link = await DynamicLinksService()
                        .createDynamicLinkForRequest(widget.model);

                    await Share.share(link);
                    Navigator.pop(context);
                  },
                  message: "Share",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
