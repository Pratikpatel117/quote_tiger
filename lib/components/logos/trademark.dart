import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/provider/globals_provider.dart';

class Trademark extends StatelessWidget {
  const Trademark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalsProvider globalsProvider = Provider.of<GlobalsProvider>(context);

    return InkWell(
        onTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          globalsProvider.setCurrentPage(0);
        },
        child:
            SizedBox(height: 52, child: Image.asset('assets/logo/tiger.png')));
  }
}
