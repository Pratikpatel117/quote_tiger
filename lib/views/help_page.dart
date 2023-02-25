import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/logos/trademark.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
            const SizedBox(
              height: 40,
              width: 40,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(children: const [
          Text(
            'Help Centre',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 70,
          ),
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          HelpTile(
            title: 'What is QuoteTiger?',
            description:
                'QuoteTiger is a Request based marketplace. All business starts with a need, a requirement that needs filling, so we started there. Tap + to post your requirement and sellers can contact you to provide quotes.',
          ),
          Divider(),
          HelpTile(
            title: 'What is a request?',
            description:
                'Your requests are personalised requirements that include all relevant details for a product that you need. This allows the seller to see exactly what your requirements are and quote you for those reducing unnecessary back and forth which saves time. You can even upload photos and documents to show specifics of your product.',
          ),
          Divider(),
          HelpTile(
              title: 'Does QuoteTiger source products for me?',
              description:
                  'QuoteTiger is a platform to connect buyers and sellers, our team does not source products. We provide a better solution for businesses to connect and receive quotes for their specific requirements.'),
          Divider(),
          HelpTile(
              title: 'I am a business can I use QuoteTiger?',
              description:
                  'QuoteTiger can be used by individuals and businesses. '),
          Divider(),
          HelpTile(
              title: 'Are there any fees?',
              description:
                  'There are no fees, no commission and no restrictions on your requirements.')
        ]),
      ),
    );
  }
}

class HelpTile extends StatefulWidget {
  final String title;
  final String description;
  const HelpTile({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<HelpTile> createState() => _HelpTileState();
}

class _HelpTileState extends State<HelpTile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(0),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        children: [
          Text(
            widget.description,
            style: const TextStyle(),
          )
        ],
      ),
    );
  }
}
