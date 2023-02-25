import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Widget? action;
  const ErrorMessage({Key? key, required this.message, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
