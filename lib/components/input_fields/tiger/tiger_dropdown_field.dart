import 'package:flutter/material.dart';

import '../../icons/qicon.dart';

class QuoteTigerDropdownButton extends StatefulWidget {
  final TextEditingController controller;
  final List<String> choices;
  final String? title;
  final String? prefix;
  final Function(String)? onChanged;
  const QuoteTigerDropdownButton({
    Key? key,
    required this.controller,
    required this.choices,
    this.onChanged,
    this.title,
    this.prefix,
  }) : super(key: key);

  @override
  State<QuoteTigerDropdownButton> createState() =>
      _QuoteTigerDropdownButtonState();
}

class _QuoteTigerDropdownButtonState extends State<QuoteTigerDropdownButton> {
  @override
  void initState() {
    if (!widget.choices.contains(widget.controller.text)) {
      widget.controller.text = widget.choices[0];
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
          items: widget.choices.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
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
