// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';
import 'package:quote_tiger/views/search/user_search/user_result_page.dart';

import '../../../../controllers/singletons/algolia_search.dart';
import '../../../utils/push.dart';

ThemeData appBarTheme(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return theme.copyWith(
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
    appBarTheme: AppBarTheme(
      iconTheme: theme.primaryIconTheme.copyWith(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: theme.inputDecorationTheme.hintStyle,
      border: InputBorder.none,
    ),
  );
}

class UserSearchPage extends StatefulWidget {
  final String initialQuery;
  final bool focusOnSearch;
  const UserSearchPage(
      {Key? key, required this.initialQuery, this.focusOnSearch = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  FocusNode focusNode = FocusNode();
  final algolia = AlgoliaSingleton().algolia.instance;
  TextEditingController controller = TextEditingController();
  List<UserModel> suggestedModels = [];
  String query = '';

  Future<List<UserModel>> suggest() async {
    ///TODO: fix filtering in search
    var objects = await algolia
        .index('user_SEARCH')
        .query(query)
        .setQueryType(QueryType.prefixLast)
        .setLength(5)
        .getObjects();
    var models = <UserModel>[];
    for (var obj in objects.hits) {
      models.add(UserModel.fromAlgoliaSnapshot(obj));
    }

    return models;
  }

  @override
  void initState() {
    query = widget.initialQuery;
    controller.text = widget.initialQuery;
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = appBarTheme(context);

    return Semantics(
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
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
            elevation: 0,
            title: TextField(
              controller: controller,
              style: theme.textTheme.headline6,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              focusNode: focusNode,
              onSubmitted: (String _) {
                focusNode.unfocus();
                if (controller.text.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (ctx, a, b) => UserSearchResultPage(
                        query: algolia
                            .index('user_SEARCH')
                            .query(query)
                            .setQueryType(QueryType.prefixLast),
                      ),
                      transitionDuration: Duration.zero,
                    ),
                  );
                }
              },
              decoration: const InputDecoration(hintText: 'Search'),
              onChanged: (e) {
                query = e;
                suggest().then((value) {
                  setState(() {
                    suggestedModels = value;
                  });
                });
              },
            ),
            leading: Padding(
                padding: const EdgeInsets.all(8), child: GoBackButton(context)),
            actions: [
              IconButton(
                  onPressed: () {
                    focusNode.unfocus();
                    if (controller.text.isNotEmpty) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (ctx, a, b) => UserSearchResultPage(
                            query: algolia
                                .index('user_SEARCH')
                                .query(query)
                                .setQueryType(QueryType.prefixLast),
                          ),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  icon: QIcon(QIcons.search))
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFFCA205),
                  Color(0xFFFFC55F),
                ],
              ),
            ),
            child: ListView.builder(
                itemCount: suggestedModels.length,
                itemBuilder: (ctx, index) {
                  return UserSearchSuggestionWidget(
                      model: suggestedModels[index]);
                }),
          ),
        ),
      ),
    );
  }
}

class UserSearchSuggestionWidget extends StatelessWidget {
  final UserModel model;
  const UserSearchSuggestionWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(model.fullName),
      leading: QIcon(QIcons.search),
      trailing: const Icon(Icons.north_west),
      onTap: () {
        push(context, ProfilePage(model: model));
      },
    );
  }
}
