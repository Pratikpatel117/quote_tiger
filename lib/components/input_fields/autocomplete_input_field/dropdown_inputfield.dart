import 'package:flutter/material.dart';

import 'fluttersdk_autocomplete.dart';

class DropdownTextInputField extends StatelessWidget {
  final List<String> options;
  final TextEditingController controller;
  final String hint;
  final String? initialValue;
  final Icon? prefix;
  const DropdownTextInputField({
    Key? key,
    required this.options,
    required this.controller,
    this.hint = 'Pick Country',
    this.initialValue,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuggestionInputField<String>(
      prefix: prefix,
      initialValue:
          initialValue != null ? TextEditingValue(text: initialValue!) : null,
      hint: hint,
      optionsBuilder: (TextEditingValue textEditingValue) {
        List<String> possible = [];

        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        var add = true;
        for (var word in options) {
          add = true;
          for (var i = 0;
              i < word.length && i < textEditingValue.text.length;
              i++) {
            if (word.toLowerCase()[i] !=
                textEditingValue.text.toLowerCase()[i]) {
              add = false;
              break;
            }
          }
          if (add) {
            possible.add(word);
          }
        }

        return possible;
      },
      onSelected: (String selection) {
        controller.text = selection;
        debugPrint('You just selected $selection');
      },
    );
  }
}
