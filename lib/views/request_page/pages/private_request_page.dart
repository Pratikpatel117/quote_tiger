import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/components/buttons/filled_icon_button.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/controllers/attached_file_controller.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/services/firebase/dynamic_link_service.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:quote_tiger/utils/flags.dart';
import 'package:quote_tiger/views/request_page/pages/edit_request_page.dart';
import 'package:quote_tiger/views/request_page/sent_quotes_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/icons/qicon.dart';
import '../../../components/tiles/attached_file/downloadable_attached_file_tile.dart';
import '../../../models/quote.dart';
import '../../../controllers/pagination/pagination_controller.dart';
import '../../../utils/interval_since_right_now.dart';

class PrivateRequestPage extends StatefulWidget {
  final RequestModel model;
  final UserModel? buyerModel;
  const PrivateRequestPage({Key? key, required this.model, this.buyerModel})
      : super(key: key);

  @override
  State<PrivateRequestPage> createState() => PrivateRequestPageState();
}

class PrivateRequestPageState extends State<PrivateRequestPage> {
  late PaginationController<QuoteModel> paginationService;
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

    return Row(
      children: [
        // user image
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
        )
      ],
    );
  }

  Future<Widget> buildQuoteSection(AuthProvider authProvider) async {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quotes",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SentQuotesListWidget(
          controller: scrollController,
          paginationService: paginationService,
          model: widget.model,
        ),
      ],
    );
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
              Row(
                children: [
                  FilledIconButton(
                    icon: QIcons.share,
                    onPressed: () async {
                      var link = await DynamicLinksService()
                          .createDynamicLinkForRequest(widget.model);
                      Share.share(link);
                    },
                  ),
                  FilledIconButton(
                      size: 40,
                      icon: QIcons.edit,
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    RequestEditPage(model: widget.model)));
                        setState(() {});
                      }),
                ],
              )
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

  Column buildAboutSection(UserModel userModelProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 2,
        ),
        if (userModelProvider.id == widget.model.creatorID)
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
  void initState() {
    paginationService = PaginationController(
        query: FirebaseFirestore.instance
            .collection('requests')
            .doc(widget.model.id)
            .collection('quotes')
            .orderBy('creation_date', descending: true),
        documentToModel: (e) => QuoteModel.fromSnapshot(e));

    paginationService.firstBatch().then((value) => setState(() {}));

    scrollController.addListener(() {
      //paginationService.nextBatch().then((value) => setState(() {}));
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent ||
          scrollController.position.maxScrollExtent == 0) {
        paginationService.nextBatch().then((value) {
          setState(() {});
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModelProvider = Provider.of<UserModel>(context);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
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
                        if (widget.model.fileUrls.isNotEmpty)
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
                ]),
              ),
            ];
          },
          body: FutureBuilder(
            //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            future: buildQuoteSection(authProvider),
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
        ),
      ),
    );
  }
}
