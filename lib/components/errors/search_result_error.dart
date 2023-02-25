import 'package:flutter/material.dart';
import 'package:quote_tiger/components/errors/error_message.dart';

class NoSearchResultsError extends StatelessWidget {
  const NoSearchResultsError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ErrorMessage(
      message:
          'Unfortunately, your search returned no results. Try again with different keywords',
    );
  }
}
