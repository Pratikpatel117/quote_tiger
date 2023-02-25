import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/filled_icon_button.dart';
import 'package:quote_tiger/components/country_picker.dart';
import 'package:quote_tiger/components/errors/error_message.dart';
import 'package:quote_tiger/components/input_fields/tiger/tiger_dropdown_field.dart';
import 'package:quote_tiger/controllers/pagination/pagination_controller.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:quote_tiger/models/request.dart';

import '../../components/buttons/empty_button.dart';
import '../../components/buttons/filled_button.dart';
import '../../components/icons/qicon.dart';
import '../../components/tiles/request_tile.dart';
import '../../models/sector/sector.dart';
import '../../services/utils_service.dart';
import '../../utils/flags.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    // I needed to acces the provider in order to get the userModel so I put the Feed itself in another widget to be able to do that.
    // (you can't acces the provider from the init state, you know)
    return RequestFeed(userModel: userModelProvider);
  }
}

class RequestFeed extends StatefulWidget {
  final UserModel userModel;
  const RequestFeed({Key? key, required this.userModel}) : super(key: key);

  @override
  State<RequestFeed> createState() => _RequestFeedState();
}

class _RequestFeedState extends State<RequestFeed> {
  final ScrollController scrollController = ScrollController();
  late PaginationController<RequestModel> paginationController;
  final TextEditingController sectorPickerController =
      TextEditingController(text: 'All');
  final TextEditingController countryPickerController =
      TextEditingController(text: 'All');

  void getPaginationController() {
    paginationController = PaginationController(
      query: FirebaseFirestore.instance
          .collection('requests')
          .orderBy('creation_date', descending: true)
          .where("is_active", isEqualTo: true),
      documentToModel: (snap) => RequestModel.fromSnapshot(snap),
    );
  }

  @override
  void initState() {
    getPaginationController();
    paginationController.firstBatch(limit: 5).then((value) {
      setState(() {});
    });

    paginationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    paginationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Persistent AppBar that never scrolls

      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
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
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Latest Requests',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                letterSpacing: -0.02,
                              ),
                            ),
                            FilledIconButton(
                              passiveFillColor: const Color(0xFFFCA205),
                              passiveIconColor: Colors.white,
                              icon: QIcons.hamburgerLeft,
                              onPressed: () {
                                filterDialog(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ];
          },
          // You tab view goes here

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              switch (paginationController.getState) {
                case PaginationState.empty:
                  return ErrorMessage(
                    message:
                        'It\'s very empty out here. This could be a problem on our end but it\'s probably because you didn\'t pick any sectors to watch',
                    action: TextButton(
                        onPressed: () async {
                          paginationController.refresh();
                          await paginationController.firstBatch();
                          setState(() {});
                        },
                        child: const Text("Refresh")),
                  );
                case PaginationState.loading:
                  return const Center(child: CircularProgressIndicator());

                default:
                  return RefreshIndicator(
                    onRefresh: () async {
                      paginationController.refresh();
                      await paginationController.firstBatch();
                      setState(() {});
                    },
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: paginationController.documentModels.length + 1,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        if (paginationController.documentModels.length ==
                            index) {
                          if (paginationController.getState ==
                              PaginationState.done) {
                            return const ListTile(
                              title: Center(child: Text('No more requests')),
                            );
                          }

                          if (scrollController.position.atEdge) {
                            paginationController
                                .nextBatch(limit: 5)
                                .then((value) {
                              setState(() {});
                            });
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        //if (experimentalPaginationController.done) {
                        //return estTile(model: experimentalPaginationController.currentItems[index]);
                        return RequestTile(
                            paginationController: paginationController,
                            model: paginationController.documentModels[index]);
                      }),
                    ),
                  );
              }
            }),
          ),
        ),
      ),
    );
  }

  Future<dynamic> filterDialog(BuildContext context) {
    // countryPickerController.text = 'All';
    // sectorPickerController.text = 'All';
    return showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                      future: DiverseServices.getSectors(limit: 10),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return QuoteTigerDropdownButton(
                              title: 'Sector',
                              choices: const ['All'],
                              controller: TextEditingController(text: 'All'));
                        }
                        var models = snap.data as List<SectorModel>;
                        List<String> names = [];
                        for (var model in models) {
                          names.add(model.name);
                        }
                        names = <String>{...names}.toList();
                        names.insert(0, 'All');

                        return QuoteTigerDropdownButton(
                            title: 'Sector',
                            choices: names,
                            controller: sectorPickerController);
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  CountryPicker(
                    initialValue: 'All',
                    prefix:
                        getFlagFromCountryName(countryPickerController.text),
                    title: 'Country',
                    controller: countryPickerController,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EmptyTextButton(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 48,
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor))),
                      FilledTextButton(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 48,
                          fontSize: 17,
                          onPressed: () {
                            Query<Object?> query = getNewQuery();
                            paginationController.resetWithNewQuery(query);
                            paginationController
                                .firstBatch(limit: 5)
                                .then((value) {
                              setState(() {});
                            });
                            Navigator.pop(ctx);
                          },
                          message: 'Filter'),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Query<Object?> getNewQuery() {
    late Query query;

    var noneWerePicked = countryPickerController.text == 'All' &&
        sectorPickerController.text == 'All';

    if (noneWerePicked) {
      query = FirebaseFirestore.instance
          .collection('requests')
          .orderBy('creation_date', descending: true)
          .where("is_active", isEqualTo: true);
    }

    var onlyCountryWasPicked = countryPickerController.text != 'All' &&
        sectorPickerController.text == 'All';
    if (onlyCountryWasPicked) {
      query = FirebaseFirestore.instance
          .collection('requests')
          .where('location', isEqualTo: countryPickerController.text)
          .orderBy('creation_date', descending: true);
    }

    final onlySectorWasPicked = countryPickerController.text == 'All' &&
        sectorPickerController.text != 'All';
    if (onlySectorWasPicked) {
      query = FirebaseFirestore.instance
          .collection('requests')
          .where('sector', isEqualTo: sectorPickerController.text)
          .orderBy('creation_date', descending: true);
    }

    var bothWerePicked = countryPickerController.text != 'All' &&
        sectorPickerController.text != 'All';
    if (bothWerePicked) {
      query = FirebaseFirestore.instance
          .collection('requests')
          .where('sector', isEqualTo: sectorPickerController.text)
          .where('location', isEqualTo: countryPickerController.text)
          .orderBy('creation_date', descending: true);
    }

    return query;
  }
}
