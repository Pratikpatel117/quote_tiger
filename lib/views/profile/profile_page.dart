import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/empty_button.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/buttons/toggable/toggle_button.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/chat/chat.dart';
import 'package:quote_tiger/services/firebase/dynamic_link_service.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:quote_tiger/utils/flags.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/profile/edit_profile_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/icons/qicon.dart';
import '../../components/tiles/request_tile.dart';
import '../../models/chat/chat.dart';

class ProfilePage extends StatefulWidget {
  final UserModel model;
  const ProfilePage({Key? key, required this.model}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool chatCreationToggle = false;
  ChatService chatSystem = ChatService();
  ChatModel? chatModel;
  List<RequestModel> requestModels = [];
  Widget buildProfile(UserModel userModel) {
    return Row(
      children: [
        // user image
        Center(
          child: CircleAvatar(
              radius: 38, backgroundImage: NetworkImage(userModel.image)),
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
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: -0.7,
              ),
            ),
            Row(
              children: [
                Text(
                  '@${userModel.username}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFFC6C6C8),
                    letterSpacing: -0.7,
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
                  '${getFlagFromCountryName(userModel.location)}  ${userModel.location}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFFC6C6C8),
                    letterSpacing: -0.7,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Future<List<RequestModel>> getRequests() async {
    if (requestModels.isEmpty) {
      requestModels = await widget.model.getCreatedRequests;
    }
    return requestModels;
  }

  @override
  void initState() {
    getRequests().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    return Scaffold(
      // Persistent AppBar that never scrolls
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
            const SizedBox(width: 40, height: 40),
          ],
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            // allows you to build a list of elements that would be scrolled away till the body reached the top
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.model.id == userModelProvider.id)
                                buildProfile(userModelProvider)
                              else
                                buildProfile(widget.model),
                              const SizedBox(
                                height: 14,
                              ),
                              Text(
                                widget.model.id == userModelProvider.id
                                    ? userModelProvider.description
                                    : widget.model.description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xFF28282A),
                                  letterSpacing: -0.7,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              buildSocialMedias(
                                  widget.model.id == userModelProvider.id
                                      ? userModelProvider
                                      : widget.model),
                              Text(
                                (widget.model.id == userModelProvider.id
                                        ? userModelProvider.website
                                        : widget.model.website) ??
                                    '',
                                style: const TextStyle(
                                    color: Color(0xFFFCA205),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (widget.model.id == userModelProvider.id)
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomFilledButton(
                                        height: 48,
                                        onPressed: () async {
                                          await push(
                                              context,
                                              EditProfilePage(
                                                localUser: userModelProvider,
                                              ));
                                          setState(() {});
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            QIcon(
                                              QIcons.editProfile,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
                                              'Edit profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    EmptyTextButton(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height: 48,
                                        onPressed: () async {
                                          var link = await DynamicLinksService()
                                              .createDynamicLinkForUser(
                                                  widget.model);

                                          await Share.share(link.toString());
                                        },
                                        child: QIcon(
                                          QIcons.share,
                                          color: Theme.of(context).primaryColor,
                                          size: 25,
                                        )),
                                  ],
                                )
                              else
                                Row(children: [
                                  Expanded(
                                    child: CustomFilledButton(
                                      height: 48,
                                      onPressed: () async =>
                                          await chatSystem.createOrOpenChat(
                                              context,
                                              widget.model,
                                              userModelProvider),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          QIcon(
                                            QIcons.message,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            'Send a message',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  OldCustomToggableIconButton(
                                      height: 48,
                                      width: MediaQuery.of(context).size.width *
                                          (1 / 5),
                                      icon: QIcons.star,
                                      isActive: userModelProvider.savedProfiles
                                          .contains(widget.model.id),
                                      onToggle: (active) {
                                        if (!active) {
                                          userModelProvider.addProfileBookmark(
                                              widget.model.id);
                                        } else {
                                          userModelProvider
                                              .removeProfileBookmark(
                                                  widget.model.id);
                                        }
                                      }),
                                ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ];
            },
            // You tab view goes here
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Requests',
                    style: TextStyle(
                      color: Color(0xFFFCA205),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: requestModels.isEmpty
                      ? FutureBuilder(
                          future: getRequests(),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                    ConnectionState.waiting ||
                                !snap.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snap.hasError) {
                              return const Text('An error has occurred');
                            }
                            return CreatedRequestList(
                              requests: snap.data as List<RequestModel>,
                            );
                          },
                        )
                      : CreatedRequestList(requests: requestModels),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSocialMedias(UserModel userModel) {
    var primary = Theme.of(context).primaryColor;
    userModel.facebook;
    return Row(
      children: [
        if (userModel.facebook != null && userModel.facebook!.trim() != "")
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                print(userModel.facebook);
                print(userModel.facebook?.trim());
                if (userModel.facebook == null ||
                    userModel.facebook?.trim() == '') {
                  return;
                }
                if (!Uri.parse(userModel.facebook!).isAbsolute) {
                  showError(context, "Not a valid url");
                  return;
                }
                launchUrl(Uri.parse(userModel.facebook!));
              },
              icon: Icon(
                Icons.facebook,
                color: primary,
                size: 30,
              )),
        if (userModel.twitter != null && userModel.twitter!.trim() != "")
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (userModel.twitter == null ||
                  userModel.twitter?.trim() == '') {
                return;
              }
              if (!Uri.parse(userModel.twitter!).isAbsolute) {
                showError(context, "Not a valid url");
                return;
              }
              launchUrl(Uri.parse(userModel.twitter!));
            },
            icon: SvgPicture.asset(
              "assets/brands/twitter.svg",
              color: primary,
              width: 30,
            ),
          ),
        if (userModel.instagram != null && userModel.instagram!.trim() != "")
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (userModel.instagram == null ||
                  userModel.instagram?.trim() == '') {
                print(userModel.instagram);
                return;
              }

              if (!Uri.parse(userModel.instagram!).isAbsolute) {
                showError(context, "Not a valid url");
                return;
              }

              launchUrl(Uri.parse(userModel.instagram!));
            },
            icon: SvgPicture.asset(
              "assets/brands/instagram.svg",
              color: primary,
              width: 30,
            ),
          ),
        if (userModel.linkedin != null && userModel.linkedin!.trim() != "")
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              if (userModel.linkedin == null ||
                  userModel.linkedin!.trim() == "") {
                return;
              }
              if (!Uri.parse(userModel.linkedin!).isAbsolute) {
                showError(context, "Not a valid url");
                return;
              }

              await launchUrl(Uri.parse(userModel.linkedin!));
            },
            icon: SvgPicture.asset(
              "assets/brands/linkedin.svg",
              color: primary,
              width: 30,
            ),
          ),
      ],
    );
  }
}

class CreatedRequestList extends StatefulWidget {
  final List<RequestModel> requests;
  const CreatedRequestList({
    Key? key,
    required this.requests,
  }) : super(key: key);

  @override
  State<CreatedRequestList> createState() => _CreatedRequestListState();
}

class _CreatedRequestListState extends State<CreatedRequestList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: widget.requests.length,
        separatorBuilder: (BuildContext ctx, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RequestTile(
              model: widget.requests[index],
            ),
          );
        });
  }
}

class ProfilePageRoute extends StatefulWidget {
  final String userID;
  const ProfilePageRoute({Key? key, required this.userID}) : super(key: key);

  @override
  State<ProfilePageRoute> createState() => _ProfilePageRouteState();
}

class _ProfilePageRouteState extends State<ProfilePageRoute> {
  late UserModel profileUserModel;
  bool done = false;

  @override
  void initState() {
    UserService.getUserById(widget.userID, getSectors: false).then((value) {
      setState(() {
        done = true;
        profileUserModel = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ProfilePage(
      model: profileUserModel,
    );
  }
}
