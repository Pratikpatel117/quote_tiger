import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    Key? key,
    required this.controller,
    required this.hint,
    this.keyboard,
    this.maxLength = 200,
    this.hideCount = true,
    this.isPassword = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.maxLines = 1,
    this.autoFocus = false,
    this.customPadding = false,
    this.validate,
  }) : super(key: key);

  final Icon? prefix;
  final bool isPassword;
  final int maxLength;
  final int? maxLines;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String hint;
  final bool hideCount;
  final Function(String)? onChanged;
  final FormFieldSetter<String>? onSubmitted;
  final bool customPadding;
  final FocusNode? focusNode;
  final bool autoFocus;
  final String? Function(String)? validate;

  final IconButton? suffix;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool visible = true;
  @override
  void initState() {
    visible = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      obscureText: visible,
      onFieldSubmitted: widget.onSubmitted,
      maxLength: widget.maxLength,
      controller: widget.controller,
      keyboardType: widget.keyboard,
      textAlign: TextAlign.start,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        errorText: widget.validate == null
            ? null
            : widget.validate!(widget.controller.text),
        prefixIcon: widget.prefix,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: visible
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    visible = !visible;
                  });
                },
              )
            : widget.suffix,
        counter: widget.hideCount ? const Offstage() : null,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        hintText: widget.hint,
      ),
    );
  }
}
