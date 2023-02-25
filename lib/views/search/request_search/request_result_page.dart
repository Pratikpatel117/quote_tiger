import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:quote_tiger/components/tiles/profile_tile.dart';
import 'package:quote_tiger/components/tiles/request_tile.dart';
import 'package:quote_tiger/controllers/pagination/algolia_pagination_controller.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/views/search/request_search/request_search_page.dart';

import '../../../components/buttons/filled_icon_button.dart';
import '../../../components/icons/qicon.dart';

class RequestSearchResultPage extends StatefulWidget {
  final AlgoliaQuery requestQuery;
  final AlgoliaQuery userQuery;
  const RequestSearchResultPage(
      {Key? key, required this.requestQuery, required this.userQuery})
      : super(key: key);

  @override
  State<RequestSearchResultPage> createState() =>
      _RequestSearchResultPageState();
}

class _RequestSearchResultPageState extends State<RequestSearchResultPage> {
  ScrollController requestScrollController = ScrollController();
  ScrollController userScrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  late AlgoliaPaginationService requestPaginationService;
  late AlgoliaPaginationService userPaginationService;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    initRequestPagination();
    initUserPagination();
    controller.text = widget.requestQuery.parameters['query'];
    initRequestScrollController();
    initUserScrollController();

    super.initState();
  }

  void initRequestScrollController() {
    requestScrollController.addListener(() {
      //paginationService.nextBatch().then((value) => setState(() {}));
      if (requestScrollController.offset >=
              requestScrollController.position.maxScrollExtent ||
          requestScrollController.position.maxScrollExtent == 0) {
        requestPaginationService.getNextBatch().then((value) {
          setState(() {});
        });
      }
    });
  }

  void initUserScrollController() {
    userScrollController.addListener(() {
      //paginationService.nextBatch().then((value) => setState(() {}));
      if (userScrollController.offset >=
              userScrollController.position.maxScrollExtent ||
          userScrollController.position.maxScrollExtent == 0) {
        userPaginationService.getNextBatch().then((value) {
          setState(() {});
        });
      }
    });
  }

  void initRequestPagination() {
    requestPaginationService = AlgoliaPaginationService(
        snapToModel: (snap) => RequestModel.fromAlgoliaSnapshot(snap),
        query: widget.requestQuery);

    requestPaginationService.getFirstBatch().then((value) {
      setState(() {});
    });
  }

  void initUserPagination() {
    userPaginationService = AlgoliaPaginationService(
        snapToModel: (snap) => UserModel.fromAlgoliaSnapshot(snap),
        query: widget.userQuery);

    userPaginationService.getFirstBatch().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    requestScrollController.dispose();
    userScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = appBarTheme(context);

    return Theme(
      data: theme,
      child: DefaultTabController(
        length: 2,
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
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoBackButton(
                context,
              ),
            ),
            title: GestureDetector(
              onTapUp: (e) {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, p1, p2) =>
                          RequestSearchPage(initialQuery: controller.text),
                      transitionDuration: Duration.zero,
                    ));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  controller.text,
                  style: theme.textTheme.headline6,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledIconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, p1, p2) => RequestSearchPage(
                            initialQuery: controller.text,
                          ),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: QIcons.search),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 12,
                    );
                  },
                  itemCount: requestPaginationService.items.length,
                  itemBuilder: (context, index) =>
                      RequestTile(model: requestPaginationService.items[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 12,
                    );
                  },
                  itemCount: userPaginationService.items.length,
                  itemBuilder: (context, index) => UserProfileTile(
                      model: userPaginationService.items[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
