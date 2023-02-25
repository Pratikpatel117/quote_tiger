import 'package:flutter/material.dart';
import 'package:quote_tiger/components/buttons/filled_icon_button.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/toggable/toggable_icon_button.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/controllers/attached_file_controller.dart';
import 'package:quote_tiger/models/quote.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/chat/chat.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:quote_tiger/utils/flags.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';
import 'package:quote_tiger/views/request_page/quote_submission.dart';

import '../../../components/icons/qicon.dart';
import '../../../components/tiles/attached_file/downloadable_attached_file_tile.dart';
import '../../../components/widgets/sent_quote_widget.dart';
import '../../../utils/interval_since_right_now.dart';

class PublicRequestPage extends StatefulWidget {
  final RequestModel model;
  final UserModel? buyerModel;
  final bool focusOnInputField;
  const PublicRequestPage(
      {Key? key,
      required this.model,
      this.buyerModel,
      this.focusOnInputField = false})
      : super(key: key);

  @override
  State<PublicRequestPage> createState() => PublicRequestPageState();
}

class PublicRequestPageState extends State<PublicRequestPage> {
  final TextEditingController quoteController = TextEditingController();
  final FileController fileController = FileController();
  final ScrollController scrollController = ScrollController();
  UserModel? userModel;
  Future<UserModel> getUser(UserModel localUser) async {
    if (userModel != null) {
      return userModel!;
    }
    if (widget.buyerModel != null) {
      userModel = widget.buyerModel!;
      return widget.buyerModel!;
    }

    if (widget.model.creatorID == localUser.id) {
      userModel = localUser;
      return localUser;
    }

    userModel = await UserService.getUserById(widget.model.creatorID,
        getSectors: false);
    return userModel!;
  }

  Future<Widget> buildProfile(UserModel localUser) async {
    UserModel userModel = await getUser(localUser);

    return InkWell(
      onTap: () {
        push(context, ProfilePage(model: userModel));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // user image
          Row(
            children: [
              Center(
                child: CircleAvatar(
                    radius: 22, backgroundImage: NetworkImage(userModel.image)),
              ),
              const SizedBox(
                width: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        intervalSinceCurrentMoment(widget.model.creationDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFAEAEB2),
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
                        '${getFlagFromCountryName(widget.model.location)}  ${widget.model.location}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFAEAEB2),
                          letterSpacing: 0.02,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          FilledIconButton(
            icon: QIcons.message,
            onPressed: () async {
              if (userModel.id == localUser.id) {
                showError(context, "You can't message yourself");
                return;
              }
              await ChatService()
                  .createOrOpenChat(context, userModel, localUser);
            },
          )
        ],
      ),
    );
  }

  Future<Widget> buildQuoteSection(UserModel userModelProvider) async {
    QuoteModel? quoteModel =
        await userModelProvider.getQuoteByLocalUserFromRequest(widget.model.id);
    if (userModelProvider.id == widget.model.creatorID) {
      //print('you gotta replace this bro');
    }
    if (quoteModel == null) {
      return QuoteSubmissionSection(
        onFinish: () {
          setState(() {});
        },
        fileController: fileController,
        focusOnInputField: widget.focusOnInputField,
        model: widget.model,
      );
    } else {
      return SentQuoteWidget(model: quoteModel);
    }
  }

  Column buildAppBar(BuildContext context, UserModel userModelProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GoBackButton(context),
              SizedBox(width: 56, child: Image.asset('assets/logo/tiger.png')),
              ToggableFilledIconButton(
                  isActive: userModelProvider.savedRequestIds
                      .contains(widget.model.id),
                  icon: QIcons.star,
                  onToggle: (state) {
                    if (!state) {
                      userModelProvider.addRequestBookmark(widget.model.id);
                    } else {
                      userModelProvider.removeRequestBookmark(widget.model.id);
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }

  Column buildRequestInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.model.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            letterSpacing: -0.01,
          ),
        ),
        Text(getFlagFromCountryName(widget.model.location) +
            ' ' +
            widget.model.location),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.model.description,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xFF525256),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<Widget> getAttachedFiles() {
    List<Widget> widgets = [];
    if (widget.model.fileUrls.isNotEmpty) {
      widgets.add(
        const Text(
          'Attached files',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF28282A),
            fontSize: 18,
          ),
        ),
      );
    }
    for (var url in widget.model.fileUrls) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: DownloadableAttachedFileTile(
          fileURL: url,
        ),
      ));
    }

    return widgets;
  }

  Widget buildAboutSection(UserModel userModelProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 2,
        ),
        if (userModelProvider.id != widget.model.creatorID)
          const Text(
            'About the buyer',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF28282A),
              fontSize: 22,
            ),
          ),
        const SizedBox(
          height: 5,
        ),
        FutureBuilder(
          future: buildProfile(userModelProvider),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return snapshot.data as Widget;
          },
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAppBar(context, userModelProvider),
                    const SizedBox(
                      height: 10,
                    ),
                    buildRequestInformation(),
                    const SizedBox(
                      height: 20,
                    ),
                    ...getAttachedFiles(),
                    if (!(userModelProvider.id == widget.model.creatorID))
                      buildAboutSection(userModelProvider),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                future: buildQuoteSection(userModelProvider),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data as Widget,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
