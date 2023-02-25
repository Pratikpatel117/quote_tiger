import 'package:flutter/material.dart';
import 'package:quote_tiger/components/scrollables/sector_list.dart';

import '../../models/sector/empty_sector_category_model.dart';
import '../../models/sector/sector_category.dart';

class SectorCategoriesWidget extends StatefulWidget {
  final List<EmptySectorCategoryModel> models;
  final double maxWidth;
  final double maxHeight;

  const SectorCategoriesWidget(
      {Key? key,
      required this.models,
      this.maxHeight = 350,
      this.maxWidth = 300})
      : super(key: key);

  @override
  State<SectorCategoriesWidget> createState() => _SectorCategoriesWidgetState();
}

class _SectorCategoriesWidgetState extends State<SectorCategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: widget.maxHeight,
      maxWidth: widget.maxWidth,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: widget.models.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
              future: widget.models[index].addSectors,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('An error has occurred');
                }

                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return const Text('Bruh');
                }

                SectorCategoryModel model =
                    snapshot.data as SectorCategoryModel;
                return SectorList(
                  model: model,
                  maxWidth: MediaQuery.of(context).size.width,
                );
              });
        },
      ),
    );
  }
}
