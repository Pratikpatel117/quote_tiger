import 'package:flutter/material.dart';

import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/utils/flags.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';

class UserProfileTile extends StatefulWidget {
  final UserModel model;
  const UserProfileTile({Key? key, required this.model}) : super(key: key);

  @override
  State<UserProfileTile> createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
  String resizeText(String initialText) {
    if (initialText.length < 70) {
      return initialText;
    }
    return initialText.substring(0, 70);
  }

  Widget buildResizedText(String initialText) {
    String newText = resizeText(initialText);
    return RichText(
        text: TextSpan(
      children: [
        TextSpan(
          text: newText,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        if (newText.length != initialText.length)
          const TextSpan(
            text: ' ...View more',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFFCA205),
              fontSize: 16,
            ),
          ),
      ],
    ));
  }

  Widget buildProfile(UserModel model) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          push(context, ProfilePage(model: widget.model));
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user image
                  CircleAvatar(
                      radius: 24, backgroundImage: NetworkImage(model.image)),
                  const SizedBox(
                    width: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: -0.7,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '@${model.username}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFFC6C6C8),
                              letterSpacing: 0.02,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC6C6C8),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Text(
                            '${getFlagFromCountryName(model.location)}  ${model.location}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFFC6C6C8),
                              letterSpacing: 0.02,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              buildResizedText(model.description),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buildProfile(widget.model)],
    );
  }
}
