import 'package:flutter/material.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/errors/error_message.dart';
import 'package:quote_tiger/components/tiles/profile_tile.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:skeletons/skeletons.dart';
import '../../components/tiles/request_tile.dart';

class FavoritedPage extends StatefulWidget {
  final bool showAppBar;
  const FavoritedPage({Key? key, this.showAppBar = true}) : super(key: key);

  @override
  State<FavoritedPage> createState() => _FavoritedPageState();
}

class _FavoritedPageState extends State<FavoritedPage> {
  AppBar? buildAppBar(BuildContext context, UserModel userModelProvider) {
    if (!widget.showAppBar) return null;
    return AppBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);

    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: buildAppBar(context, userModelProvider),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            // allows you to build a list of elements that would be scrolled away till the body reached the top

            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Favorited',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              letterSpacing: -0.02,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ];
            },
            // You tab view goes here
            body: Column(
              children: <Widget>[
                const TabBar(
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Requests',
                        style: TextStyle(
                          color: Color(0xFFFCA205),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Profiles',
                        style: TextStyle(
                          color: Color(0xFFFCA205),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      FutureBuilder(
                          future: userModelProvider.getSavedRequests,
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                    ConnectionState.waiting ||
                                !snap.hasData) {
                              return ListView(
                                children: const [
                                  SkeletonRequestTile(),
                                  SkeletonRequestTile(),
                                  SkeletonRequestTile(),
                                  SkeletonRequestTile(),
                                ],
                              );
                            }

                            if (snap.hasError) {
                              return const Text('An error has occurred');
                            }

                            var requestModels = snap.data as List<RequestModel>;

                            if (requestModels.isEmpty) {
                              return const Center(
                                child: ErrorMessage(
                                    message: "You haven't saved any requests"),
                              );
                            }

                            return ListView.separated(
                                itemCount: requestModels.length,
                                separatorBuilder: (BuildContext ctx, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: RequestTile(
                                      model: requestModels[index],
                                    ),
                                  );
                                });
                          }),
                      FutureBuilder(
                          future: userModelProvider.getSavedUserProfiles,
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                    ConnectionState.waiting ||
                                !snap.hasData) {
                              return ListView(
                                children: const [
                                  SkeletonRequestTile(),
                                  SkeletonRequestTile(),
                                ],
                              );
                            }

                            if (snap.hasError) {
                              return const Center(
                                child: ErrorMessage(
                                    message: "An error has occurred"),
                              );
                            }

                            var userModels = snap.data as List<UserModel>;

                            if (userModels.isEmpty) {
                              return const Center(
                                child: ErrorMessage(
                                    message: "You haven't saved any profiles"),
                              );
                            }

                            return ListView.separated(
                                itemCount: userModels.length,
                                separatorBuilder: (BuildContext ctx, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: UserProfileTile(
                                      model: userModels[index],
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
