import 'package:flutter/material.dart';

import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/utils/flags.dart';
import 'package:quote_tiger/utils/globals.dart';

class CountryPicker extends StatefulWidget {
  final TextEditingController controller;
  final String? title;
  final String? prefix;
  final Function(String)? onChanged;
  final String? initialValue;

  const CountryPicker({
    Key? key,
    required this.controller,
    this.initialValue,
    this.onChanged,
    this.title,
    this.prefix,
  }) : super(key: key);

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<String> choices = countries;
  @override
  void initState() {
    if (!choices.contains(widget.controller.text)) {
      if (widget.initialValue != null) {
        choices.removeAt(0);
        choices.insert(0, widget.initialValue!);
      }
      widget.controller.text = choices[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: widget.controller.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            counterStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          borderRadius: BorderRadius.circular(12),
          icon: QIcon(
            QIcons.down,
            size: 20,
          ),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newValue) {
            widget.controller.text = newValue!;
            if (widget.onChanged != null) widget.onChanged!(newValue);
          },
          items: choices.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                getFlagFromCountryName(value) + ' ' + value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFC6C6C8F)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
