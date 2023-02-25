import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:quote_tiger/components/icons/qicon.dart';
import 'package:quote_tiger/components/tiles/profile_tile.dart';
import 'package:quote_tiger/controllers/pagination/algolia_pagination_controller.dart';
import 'package:quote_tiger/models/user.dart';

import '../../../components/buttons/go_back_button.dart';
import 'user_search_page.dart';

class UserSearchResultPage extends StatefulWidget {
  final AlgoliaQuery query;
  const UserSearchResultPage({Key? key, required this.query}) : super(key: key);

  @override
  State<UserSearchResultPage> createState() => _UserSearchResultPageState();
}

class _UserSearchResultPageState extends State<UserSearchResultPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  List<UserModel> requests = [];
  late AlgoliaPaginationService paginationService;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    paginationService = AlgoliaPaginationService(
        snapToModel: (snap) => UserModel.fromAlgoliaSnapshot(snap),
        query: widget.query);

    paginationService.getFirstBatch().then((value) {
      setState(() {});
    });
    controller.text = widget.query.parameters['query'];
    scrollController.addListener(() {
      //paginationService.nextBatch().then((value) => setState(() {}));
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent ||
          scrollController.position.maxScrollExtent == 0) {
        paginationService.getNextBatch().then((value) {
          setState(() {});
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = appBarTheme(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GoBackButton(
              context,
            ),
          ),
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
          title: GestureDetector(
            onTapUp: (e) {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, p1, p2) =>
                        UserSearchPage(initialQuery: controller.text),
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
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, p1, p2) => UserSearchPage(
                      initialQuery: controller.text,
                    ),
                    transitionDuration: Duration.zero,
                  ),
                );
              },
              icon: QIcon(QIcons.search),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 12,
              );
            },
            itemCount: paginationService.items.length,
            itemBuilder: (context, index) =>
                UserProfileTile(model: paginationService.items[index]),
          ),
        ),
      ),
    );
  }
}

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
