import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/buttons/go_back_button.dart';
import '../../services/firebase/dynamic_link_service.dart';

class InvitePage extends StatefulWidget {
  final bool isPopUp;
  const InvitePage({Key? key, this.isPopUp = false}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildConstantSection(context),
                if (widget.isPopUp)
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Go to home screen"),
                    ),
                  ),
                const SizedBox(),
              ]),
        ),
      ),
    );
  }

  Column buildConstantSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildAppBar(),
        const SizedBox(
          height: 60,
        ),
        const Text(
          "Invite Your Contacts",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Text(
          "Invite your contacts. Invite your business contacts to make QuoteTiger even more useful for you. More contacts, More quotes, More opportunities.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 80,
        ),
        FilledTextButton(
            onPressed: () async {
              var link = await DynamicLinksService().createDynamicLinkForApp();

              await Share.share(link);
            },
            width: MediaQuery.of(context).size.width,
            message: 'Share'),
      ],
    );
  }

  ListView buildButtonList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        buildSvgButton('assets/brands/twitter.svg', 'Twitter', () async {
          var link = await DynamicLinksService().createDynamicLinkForApp();

          await Share.share(link);
        }, isFirst: true),
        buildIconButton(
          Icons.facebook,
          'facebook',
          () async {
            var link = await DynamicLinksService().createDynamicLinkForApp();

            await Share.share(link);
          },
        ),
        buildSvgButton(
          'assets/brands/whatsapp.svg',
          'WhatsApp',
          () async {
            var link = await DynamicLinksService().createDynamicLinkForApp();

            await Share.share(link);
          },
          color: Colors.green,
        ),
        buildSvgButton(
          'assets/brands/instagram.svg',
          'instagram',
          () async {
            var link = await DynamicLinksService().createDynamicLinkForApp();

            await Share.share(link);
          },
          color: Colors.black,
        ),
        buildIconButton(
          Icons.sms,
          'sms',
          () async {
            var link = await DynamicLinksService().createDynamicLinkForApp();

            await Share.share(link);
          },
          color: Colors.cyan.shade800,
        ),
      ],
    );
  }

  Widget buildSvgButton(String assetPath, String name, VoidCallback onPressed,
      {Color color = Colors.lightBlue,
      double size = 20,
      double padding = 7,
      bool isFirst = false}) {
    return Padding(
      padding:
          EdgeInsets.only(top: 8.0, bottom: 8, right: 8, left: isFirst ? 0 : 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: SvgPicture.asset(
                  assetPath,
                  width: size,
                  height: size,
                  color: color,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                letterSpacing: 0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(IconData icon, String name, VoidCallback onPressed,
      {Color color = Colors.lightBlue, bool isFirst = false}) {
    return Padding(
      padding:
          EdgeInsets.only(top: 8.0, bottom: 8, right: 8, left: isFirst ? 0 : 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Center(
                  child: Icon(
                    icon,
                    size: 25,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                letterSpacing: 0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildAppBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GoBackButton(
                context,
                isPopUp: widget.isPopUp,
              ),
              SizedBox(width: 56, child: Image.asset('assets/logo/tiger.png')),
              const SizedBox(
                width: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
