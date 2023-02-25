import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/controllers/sector_picker_controller.dart';
import 'package:quote_tiger/models/sector/sector.dart';
import 'package:quote_tiger/models/sector/sector_category.dart';
import 'package:quote_tiger/provider/auth_provider.dart';

import '../icons/qicon.dart';

class SectorList extends StatefulWidget {
  final SectorCategoryModel model;
  final double maxWidth;
  final double maxHeight;

  const SectorList(
      {Key? key,
      required this.model,
      this.maxHeight = 175,
      this.maxWidth = 300})
      : super(key: key);

  @override
  State<SectorList> createState() => _SectorListState();
}

class _SectorListState extends State<SectorList> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.model.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        LimitedBox(
          maxHeight: widget.maxHeight,
          maxWidth: widget.maxWidth,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              width: 12,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: widget.model.sectors.length,
            itemBuilder: (context, index) {
              return SectorWidget(
                model: widget.model.sectors[index],
                controller: authProvider.sectorPickerController,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SectorWidget extends StatefulWidget {
  final SectorModel model;
  final SectorPickerController controller;
  final double width;
  final double height;
  const SectorWidget(
      {Key? key,
      required this.model,
      required this.controller,
      this.width = 175,
      this.height = 137})
      : super(key: key);

  @override
  State<SectorWidget> createState() => _SectorWidgetState();
}

class _SectorWidgetState extends State<SectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.model.toggle(widget.controller);
          });
        },
        child: SizedBox(
          //duration: const Duration(milliseconds: 500),
          //curve: Curves.easeOutQuint,
          height: widget.height,
          width: widget.width,
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: widget.model.picked ? 10 : 2,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: widget.height,
                    width: widget.width,
                    color: Colors.lightBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.model.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: CircleAvatar(
                      radius: widget.model.picked ? 12 : 10,
                      backgroundColor: widget.model.picked
                          ? Colors.orange
                          : Colors.transparent,
                      child: QIcon(
                        QIcons.check,
                        color: widget.model.picked
                            ? Colors.white
                            : Colors.transparent,
                        size: 13,
                      ),
                    ),
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
