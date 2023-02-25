import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/toggable/toggable_icon_button.dart';
import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/controllers/pagination/pagination_controller.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/chat/chat.dart';
import 'package:quote_tiger/utils/interval_since_right_now.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';
import 'package:quote_tiger/views/request_page/pages/edit_request_page.dart';
import 'package:quote_tiger/views/request_page/request_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';
import '../../services/firebase/dynamic_link_service.dart';
import '../../services/user.dart';
import '../../utils/flags.dart';
import '../buttons/filled_icon_button.dart';

class RequestTile extends StatefulWidget {
  final RequestModel model;
  final PaginationController<RequestModel>? paginationController;
  const RequestTile({
    Key? key,
    required this.model,
    this.paginationController,
  }) : super(key: key);

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  int newDocs = 0;
  bool canShare = true;
  UserModel? currentUser;
  ChatService chatSystem = ChatService();
  Widget buildUserCard(UserModel userModel) {
    return Row(
      children: [
        // user image
        Center(
          child: CircleAvatar(
              radius: 21, backgroundImage: NetworkImage(userModel.image)),
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
                  '${getFlagFromCountryName(widget.model.location)}  ${widget.model.location}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFFC6C6C8),
                    letterSpacing: -0.7,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildResizedText(String initialText) {
    return SizedBox(
      height: 50,
      child: Text(
        initialText,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<UserModel> getUser(UserModel localUser) async {
    if (widget.model.creatorID == localUser.id) {
      return localUser;
    }

    if (currentUser != null) {
      return currentUser!;
    }
    newDocs = newDocs + 1;
    currentUser = await UserService.getUserById(widget.model.creatorID,
        getSectors: false);
    return currentUser!;
  }

  void pushEditPage() {
    push(
        context,
        RequestEditPage(
          model: widget.model,
        )).then((value) {
      setState(() {});
    });
  }

  Widget buildMenu() {
    return PopupMenuButton(
      onSelected: (obj) {
        if (obj == 1) {
          pushEditPage();
        }
      },
      child: FilledIconButton(
        size: 45,
        icon: QIcons.menu,
      ),
      itemBuilder: (ctx) => [
        _buildPopupMenuItem(widget.model.isActive ? 'Deactivate' : 'Activate',
            value: 0, onPressed: () async {
          widget.model.toggleActivation();
          setState(() {});
        }),
        _buildPopupMenuItem(
          'Edit',
          value: 1,
          onPressed: () {},
        ),
        _buildPopupMenuItem('Delete', value: 2, onPressed: () async {
          await FirebaseFirestore.instance
              .collection('requests')
              .doc(widget.model.id)
              .delete();

          if (widget.paginationController != null) {
            widget.paginationController!.deleteModel((model) {
              if (model.id == widget.model.id) {
                return true;
              }
              return false;
            });
          }
        }),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title,
      {required VoidCallback onPressed, required int value}) {
    return PopupMenuItem(
      value: value,
      onTap: onPressed,
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);

    return Card(
      color: widget.model.isActive ? Colors.white : Colors.grey[100],
      elevation: widget.model.isActive ? 20 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: FutureBuilder(
          future: getUser(userModelProvider),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const SkeletonRequestTile()
                : InkWell(
                    onTap: () {
                      push(
                          context,
                          RequestPage(
                            model: widget.model,
                            buyerModel: snapshot.data as UserModel,
                          )).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      height: 240,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 19),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          push(
                                            context,
                                            ProfilePage(
                                                model:
                                                    snapshot.data as UserModel),
                                          );
                                        },
                                        child: buildUserCard(
                                            snapshot.data as UserModel)),
                                    if (userModelProvider.isSuperUser ||
                                        userModelProvider.id ==
                                            widget.model.creatorID)
                                      buildMenu(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.model.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    buildResizedText(
                                      widget.model.description,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  intervalSinceCurrentMoment(
                                          widget.model.creationDate)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Color(0xFFC6C6C8),
                                    letterSpacing: -0.7,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.model.isActive)
                                  FilledIconButton(
                                    size: 40,
                                    onPressed: () {
                                      push(
                                          context,
                                          RequestPage(
                                              focusOnInputField: true,
                                              buyerModel:
                                                  snapshot.data as UserModel,
                                              model: widget.model));
                                    },
                                    icon: QIcons.q,
                                  )
                                else
                                  const SizedBox(
                                    height: 40,
                                    width: 40,
                                  ),
                                FilledIconButton(
                                  size: 40,
                                  onPressed: () async =>
                                      await chatSystem.createOrOpenChat(
                                    context,
                                    snapshot.data as UserModel,
                                    userModelProvider,
                                  ),
                                  icon: QIcons.message,
                                ),
                                FilledIconButton(
                                  size: 40,
                                  onPressed: () async {
                                    if (canShare == false) {
                                      return;
                                    }
                                    canShare = false;
                                    var link = await DynamicLinksService()
                                        .createDynamicLinkForRequest(
                                            widget.model);

                                    await Share.share(link.toString());
                                    canShare = true;
                                  },
                                  icon: QIcons.share,
                                ),
                                StatelessToggableFilledIconButton(
                                  isActive: userModelProvider.savedRequestIds
                                      .contains(widget.model.id),
                                  icon: QIcons.star,
                                  onToggle: () async {
                                    if (userModelProvider.savedRequestIds
                                        .contains(widget.model.id)) {
                                      userModelProvider
                                          .removeRequestBookmark(
                                              widget.model.id)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      userModelProvider
                                          .addRequestBookmark(widget.model.id)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    }
                                  },
                                ),
                              ],
                            )
                          ]),
                    ),
                  );
          }),
    );
  }
}

class SkeletonRequestTile extends StatelessWidget {
  const SkeletonRequestTile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(color: Colors.white),
      child: SkeletonItem(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        shape: BoxShape.circle, width: 50, height: 50),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                          lines: 2,
                          spacing: 6,
                          lineStyle: SkeletonLineStyle(
                            randomLength: true,
                            height: 10,
                            borderRadius: BorderRadius.circular(8),
                            minLength: MediaQuery.of(context).size.width / 6,
                            maxLength: MediaQuery.of(context).size.width / 3,
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 6,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 2,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: 40, height: 40, shape: BoxShape.circle)),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: 40, height: 40, shape: BoxShape.circle)),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: 40, height: 40, shape: BoxShape.circle)),
              SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: 40, height: 40, shape: BoxShape.circle)),
            ],
          )
        ],
      )),
    );
  }
}
