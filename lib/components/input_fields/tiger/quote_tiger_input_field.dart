import 'package:flutter/material.dart';

import '../standard_input_field.dart';

class QuoteTigerInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String message;
  final bool isPassword;
  final Function(String)? onChanged;
  final int? maxLines;
  const QuoteTigerInputField(
      {Key? key,
      required this.controller,
      required this.hint,
      required this.message,
      this.isPassword = false,
      this.onChanged,
      this.maxLines})
      : super(key: key);

  @override
  State<QuoteTigerInputField> createState() => _QuoteTigerInputFieldState();
}

class _QuoteTigerInputFieldState extends State<QuoteTigerInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        if (widget.maxLines == null)
          TextInputField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            isPassword: widget.isPassword,
            hint: widget.hint,
          )
        else
          TextInputField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            isPassword: widget.isPassword,
            maxLines: widget.maxLines,
            hint: widget.hint,
          ),
      ],
    );
  }
}
