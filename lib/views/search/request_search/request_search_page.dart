// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/utils/push.dart';
import 'package:quote_tiger/views/profile/profile_page.dart';
import 'package:quote_tiger/views/search/request_search/request_result_page.dart';

import '../../../../components/buttons/filled_icon_button.dart';
import '../../../../controllers/singletons/algolia_search.dart';
import '../../../../models/request.dart';
import '../../../components/icons/qicon.dart';
import '../../request_page/request_page.dart';

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

class RequestSearchPage extends StatefulWidget {
  final String initialQuery;
  final bool focusOnSearch;
  const RequestSearchPage(
      {Key? key, required this.initialQuery, this.focusOnSearch = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RequestSearchPageState();
}

class _RequestSearchPageState extends State<RequestSearchPage> {
  FocusNode focusNode = FocusNode();
  final algolia = AlgoliaSingleton().algolia.instance;
  TextEditingController controller = TextEditingController();
  List<RequestModel> suggestedRequestModels = [];
  List<UserModel> suggestedUserModels = [];
  List<dynamic> suggestModels = [];
  String query = '';

  Future<List<RequestModel>> suggestRequests() async {
    if (query.isEmpty) {
      return [];
    }

    ///TODO: fix filtering in search
    var objects = await algolia
        .index('rfq_SEARCH')
        .query(query)
        .setQueryType(QueryType.prefixLast)
        .setLength(5)
        .getObjects();
    var models = <RequestModel>[];
    for (var obj in objects.hits) {
      models.add(RequestModel.fromAlgoliaSnapshot(obj));
    }

    return models;
  }

  Future<List<UserModel>> suggestUsers() async {
    if (query.isEmpty) {
      return [];
    }
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
    suggestRequests().then((value) {
      setState(() {
        suggestedRequestModels = value;
      });
    });
    suggestUsers().then((value) {
      setState(() {
        suggestedUserModels = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = appBarTheme(context);

    return Semantics(
      child: Theme(
        data: theme,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(indicatorColor: Colors.white, tabs: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Requests',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Users',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ]),
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
                  searchQuery(context);
                },
                decoration: const InputDecoration(hintText: 'Search'),
                onChanged: (e) {
                  query = e;
                  suggestRequests().then((value) {
                    setState(() {
                      suggestedRequestModels = value;
                    });
                  });
                  suggestUsers().then((value) {
                    setState(() {
                      suggestedUserModels = value;
                    });
                  });
                },
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoBackButton(
                  context,
                  size: 10,
                  onPressed: () {
                    focusNode.unfocus();
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledIconButton(
                      onPressed: () {
                        searchQuery(context);
                      },
                      icon: QIcons.search),
                )
              ],
            ),
            body: TabBarView(
              children: [
                ListView.builder(
                    itemCount: suggestedRequestModels.length,
                    itemBuilder: (ctx, index) {
                      return RequestSearchSuggestionWidget(
                          model: suggestedRequestModels[index]);
                    }),
                ListView.builder(
                    itemCount: suggestedUserModels.length,
                    itemBuilder: (ctx, index) {
                      return UserSearchSuggestionWidget(
                          model: suggestedUserModels[index]);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchQuery(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, a, b) => RequestSearchResultPage(
          userQuery: algolia
              .index('user_SEARCH')
              .query(query)
              .setQueryType(QueryType.prefixLast),
          requestQuery: algolia
              .index('rfq_SEARCH')
              .query(query)
              .setQueryType(QueryType.prefixLast),
        ),
        transitionDuration: Duration.zero,
      ),
    );
  }
}

class RequestSearchSuggestionWidget extends StatelessWidget {
  final RequestModel model;
  const RequestSearchSuggestionWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(model.title),
      leading: QIcon(QIcons.search),
      trailing: const Icon(Icons.north_west),
      onTap: () {
        push(context, RequestPage(model: model));
      },
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
