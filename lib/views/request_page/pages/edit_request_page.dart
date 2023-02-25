import 'package:flutter/material.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/buttons/filled_icon_button.dart';
import 'package:quote_tiger/components/input_fields/tiger/quote_tiger_input_field.dart';
import 'package:quote_tiger/models/request.dart';
import '../../../components/country_picker.dart';
import '../../../components/icons/qicon.dart';
import '../../../components/input_fields/tiger/tiger_dropdown_field.dart';
import '../../../components/logos/trademark.dart';
import '../../../models/sector/sector.dart';
import '../../../services/utils_service.dart';

class RequestEditPage extends StatefulWidget {
  final RequestModel model;
  const RequestEditPage({Key? key, required this.model}) : super(key: key);

  @override
  State<RequestEditPage> createState() => RequestEditPageState();
}

class RequestEditPageState extends State<RequestEditPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isTheSameThing = true;

  final TextEditingController sectorController =
      TextEditingController(text: 'Select Sector');
  final TextEditingController countryController =
      TextEditingController(text: 'Country');

  bool isTheSame() {
    if (widget.model.title != titleController.text) {
      return false;
    }
    if (widget.model.sector != sectorController.text) {
      return false;
    }
    if (widget.model.description != descriptionController.text) {
      return false;
    }

    if (widget.model.location != countryController.text) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    titleController.text = widget.model.title;
    descriptionController.text = widget.model.description;
    countryController.text = widget.model.location;
    sectorController.text = widget.model.sector ?? "None";

    super.initState();
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
            if (!isTheSame())
              FilledIconButton(
                onPressed: () async {
                  await widget.model.update(
                      title: titleController.text,
                      description: descriptionController.text,
                      country: countryController.text,
                      sector: sectorController.text.toLowerCase() == 'none'
                          ? widget.model.sector!
                          : sectorController.text);
                  Navigator.pop(context);
                },
                icon: QIcons.check,
                padding: const EdgeInsets.all(6),
              )
            else
              const SizedBox(
                width: 40,
                height: 40,
              )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            QuoteTigerInputField(
                onChanged: (e) {
                  var result = isTheSame();
                  if (result != isTheSameThing) {
                    setState(() {
                      isTheSameThing = result;
                    });
                  }
                },
                controller: titleController,
                hint: 'Enter your title',
                message: "Title"),
            QuoteTigerInputField(
                onChanged: (e) {
                  var result = isTheSame();
                  if (result != isTheSameThing) {
                    setState(() {
                      isTheSameThing = result;
                    });
                  }
                },
                controller: descriptionController,
                maxLines: 10,
                hint: 'Enter your description',
                message: "Description"),
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
                  names.insert(0, 'None');
//
                  return QuoteTigerDropdownButton(
                      onChanged: (e) {
                        var result = isTheSame();
                        if (result != isTheSameThing) {
                          setState(() {
                            isTheSameThing = result;
                          });
                        }
                      },
                      choices: names,
                      controller: sectorController);
                }),
            const SizedBox(
              height: 10,
            ),
            CountryPicker(
                onChanged: (e) {
                  var result = isTheSame();
                  if (result != isTheSameThing) {
                    setState(() {
                      isTheSameThing = result;
                    });
                  }
                },
                controller: countryController),
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}
